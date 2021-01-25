#ifndef _NIM_SDK_CPP_NIM_CHATROOM_SDK_LOADER_HELPER_H_
#define _NIM_SDK_CPP_NIM_CHATROOM_SDK_LOADER_HELPER_H_
#include "include/nim_sdk_util.h"
#include "include/callback_proxy.h"
#include "include/nim_string_util.h"
#include "include/nim_json_util.h"
#ifndef DEF_UNDER_NO_NAMESPACE
namespace nim_chatroom
{
#endif //DEF_UNDER_NO_NAMESPACE
#include "nim_res_code_def.h"
#ifndef DEF_UNDER_NO_NAMESPACE
}
#endif //DEF_UNDER_NO_NAMESPACE

namespace nim_chatroom
{
	extern nim::SDKInstance* nim_chatroom_sdk_instance;
}
#ifdef NIM_SDK_DLL_IMPORT
#define NIM_CHATROOM_SDK_GET_FUNC(function_ptr) NIM_SDK_GET_FUNC_FROM_INSTANCE(nim_chatroom_sdk_instance,function_ptr)
#else
#define NIM_CHATROOM_SDK_GET_FUNC(function_ptr) function_ptr
#endif
#endif

