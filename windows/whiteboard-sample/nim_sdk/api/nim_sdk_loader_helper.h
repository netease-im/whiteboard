#ifndef _NIM_SDK_CPP_NIM_SDK_LOADER_HELPER_H_
#define _NIM_SDK_CPP_NIM_SDK_LOADER_HELPER_H_
#include "nim_util_include.h"
#include "include/nim_sdk_util.h"
#include "include/callback_proxy.h"
#include "include/nim_string_util.h"
#include "include/nim_json_util.h"

namespace nim
{
	extern nim::SDKInstance* nim_sdk_instance;
}
#ifdef NIM_SDK_DLL_IMPORT
#define NIM_SDK_GET_FUNC(function_ptr) NIM_SDK_GET_FUNC_FROM_INSTANCE(nim_sdk_instance,function_ptr)
#else
#define NIM_SDK_GET_FUNC(function_ptr) function_ptr
#endif
#endif
