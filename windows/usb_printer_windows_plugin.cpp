#include "usb_printer_windows_plugin.h"

#include <windows.h>
#include <winspool.h>
#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <string>
#include <vector>
#include <map>

void UsbPrinterWindowsPlugin::RegisterWithRegistrar(
        flutter::PluginRegistrarWindows* registrar) {
    auto channel =
            std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
                    registrar->messenger(), "usb_printer_windows",
                            &flutter::StandardMethodCodec::GetInstance());

    auto plugin = std::make_unique<UsbPrinterWindowsPlugin>();

    channel->SetMethodCallHandler(
            [plugin_pointer = plugin.get()](const auto& call, auto result) {
                plugin_pointer->HandleMethodCall(call, std::move(result));
            });

    registrar->AddPlugin(std::move(plugin));
}

void UsbPrinterWindowsPlugin::HandleMethodCall(
        const flutter::MethodCall<flutter::EncodableValue>& method_call,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    if (method_call.method_name() == "printBytes") {
        // Extract arguments
        if (!method_call.arguments() ||
            !std::holds_alternative<flutter::EncodableMap>(*method_call.arguments())) {
            result->Error("INVALID_ARGUMENTS", "Expected a map of arguments");
            return;
        }

        const auto& arguments = std::get<flutter::EncodableMap>(*method_call.arguments());

        // Get printer name
        auto printer_name_it = arguments.find(flutter::EncodableValue("printerName"));
        if (printer_name_it == arguments.end() ||
            !std::holds_alternative<std::string>(printer_name_it->second)) {
            result->Error("INVALID_PRINTER_NAME", "Printer name is required");
            return;
        }
        std::string printer_name = std::get<std::string>(printer_name_it->second);

        // Get bytes to print
        auto bytes_it = arguments.find(flutter::EncodableValue("bytes"));
        if (bytes_it == arguments.end() ||
            !std::holds_alternative<std::vector<uint8_t>>(bytes_it->second)) {
            result->Error("INVALID_BYTES", "Bytes array is required");
            return;
        }
        std::vector<uint8_t> bytes = std::get<std::vector<uint8_t>>(bytes_it->second);

        // Print the data
        HANDLE hPrinter = nullptr;

        // Open printer
        if (!OpenPrinterA(const_cast<LPSTR>(printer_name.c_str()), &hPrinter, nullptr)) {
            result->Error("PRINTER_ERROR", "Failed to open printer",
                          flutter::EncodableValue(GetLastError()));
            return;
        }

        // Prepare document info
        DOC_INFO_1A docInfo = {};
        docInfo.pDocName = const_cast<LPSTR>("ESC/POS Print Job");
        docInfo.pOutputFile = nullptr;
        docInfo.pDatatype = const_cast<LPSTR>("RAW");

        // Start document
        if (StartDocPrinterA(hPrinter, 1, reinterpret_cast<LPBYTE>(&docInfo)) == 0) {
            ClosePrinter(hPrinter);
            result->Error("DOCUMENT_ERROR", "Failed to start document",
                          flutter::EncodableValue(GetLastError()));
            return;
        }

        // Start page
        if (StartPagePrinter(hPrinter) == 0) {
            EndDocPrinter(hPrinter);
            ClosePrinter(hPrinter);
            result->Error("PAGE_ERROR", "Failed to start page",
                          flutter::EncodableValue(GetLastError()));
            return;
        }

        // Write data
        DWORD bytes_written = 0;
        BOOL write_success = WritePrinter(
                hPrinter,
                const_cast<LPVOID>(static_cast<const void*>(bytes.data())),
                static_cast<DWORD>(bytes.size()),
                &bytes_written);

        // Clean up
        EndPagePrinter(hPrinter);
        EndDocPrinter(hPrinter);
        ClosePrinter(hPrinter);

        if (write_success && bytes_written == bytes.size()) {
            result->Success(flutter::EncodableValue(true));
        } else {
            result->Error("WRITE_ERROR", "Failed to write all bytes",
                          flutter::EncodableValue(GetLastError()));
        }

    } else if (method_call.method_name() == "getPrinters") {
        // Optional: Add method to list available printers
        DWORD needed = 0;
        DWORD returned = 0;

        EnumPrintersA(PRINTER_ENUM_LOCAL | PRINTER_ENUM_CONNECTIONS,
                      nullptr, 2, nullptr, 0, &needed, &returned);

        std::vector<BYTE> buffer(needed);
        if (EnumPrintersA(PRINTER_ENUM_LOCAL | PRINTER_ENUM_CONNECTIONS,
                          nullptr, 2, buffer.data(), needed, &needed, &returned)) {
            flutter::EncodableList printer_list;
            PPRINTER_INFO_2A printer_info = reinterpret_cast<PPRINTER_INFO_2A>(buffer.data());

            for (DWORD i = 0; i < returned; i++) {
                printer_list.push_back(flutter::EncodableValue(printer_info[i].pPrinterName));
            }
            result->Success(flutter::EncodableValue(printer_list));
        } else {
            result->Error("ENUM_ERROR", "Failed to enumerate printers",
                          flutter::EncodableValue(GetLastError()));
        }

    } else {
        result->NotImplemented();
    }
}