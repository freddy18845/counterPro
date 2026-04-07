#include "usb_printer_windows_plugin.h"
#include <windows.h>
#include <winspool.h>
#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>
#include <memory>
#include <string>
#include <vector>

void UsbPrinterWindowsPlugin::RegisterWithRegistrar(
        flutter::PluginRegistrarWindows* registrar) {
    auto channel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
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

    if (method_call.method_name() == "getPrinters") {
        _getPrinters(result);
    } else if (method_call.method_name() == "printBytes") {
        _printBytes(method_call, std::move(result));
    } else {
        result->NotImplemented();
    }
}

void UsbPrinterWindowsPlugin::_getPrinters(
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
    DWORD needed = 0, returned = 0;
    EnumPrintersA(PRINTER_ENUM_LOCAL | PRINTER_ENUM_CONNECTIONS, nullptr, 2, nullptr, 0, &needed, &returned);

    if (needed == 0) {
        result->Success(flutter::EncodableList{});
        return;
    }

    std::vector<BYTE> buffer(needed);
    if (EnumPrintersA(PRINTER_ENUM_LOCAL | PRINTER_ENUM_CONNECTIONS, nullptr, 2,
                      buffer.data(), needed, &needed, &returned)) {
        flutter::EncodableList printer_list;
        PPRINTER_INFO_2A info = reinterpret_cast<PPRINTER_INFO_2A>(buffer.data());
        for (DWORD i = 0; i < returned; ++i) {
            if (info[i].pPrinterName) {
                printer_list.push_back(flutter::EncodableValue(std::string(info[i].pPrinterName)));
            }
        }
        result->Success(printer_list);
    } else {
        result->Error("ENUM_ERROR", "Failed to list printers", flutter::EncodableValue(GetLastError()));
    }
}

void UsbPrinterWindowsPlugin::_printBytes(
        const flutter::MethodCall<flutter::EncodableValue>& method_call,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    const auto& args = std::get<flutter::EncodableMap>(*method_call.arguments());

    std::string printerName = std::get<std::string>(args.at(flutter::EncodableValue("printerName")));
    auto bytesIt = args.find(flutter::EncodableValue("bytes"));
    if (bytesIt == args.end() || !std::holds_alternative<std::vector<uint8_t>>(bytesIt->second)) {
        result->Error("INVALID_BYTES", "Bytes required");
        return;
    }
    const auto& bytes = std::get<std::vector<uint8_t>>(bytesIt->second);

    HANDLE hPrinter = nullptr;
    if (!OpenPrinterA(const_cast<char*>(printerName.c_str()), &hPrinter, nullptr)) {
        result->Error("OPEN_ERROR", "Cannot open printer", flutter::EncodableValue(GetLastError()));
        return;
    }

    DOC_INFO_1A docInfo{};
    docInfo.pDocName = const_cast<char*>("ESC/POS Receipt");
    docInfo.pDatatype = const_cast<char*>("RAW");

    if (StartDocPrinterA(hPrinter, 1, reinterpret_cast<LPBYTE>(&docInfo)) == 0) {
        ClosePrinter(hPrinter);
        result->Error("START_DOC_ERROR", "StartDoc failed", flutter::EncodableValue(GetLastError()));
        return;
    }

    DWORD written = 0;
    BOOL success = WritePrinter(hPrinter, (LPVOID)bytes.data(), (DWORD)bytes.size(), &written);

    EndDocPrinter(hPrinter);
    ClosePrinter(hPrinter);

    if (success && written == bytes.size()) {
        result->Success(flutter::EncodableValue(true));
    } else {
        result->Error("WRITE_ERROR", "Write failed", flutter::EncodableValue(GetLastError()));
    }
}