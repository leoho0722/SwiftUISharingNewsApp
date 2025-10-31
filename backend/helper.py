import os

def is_debug_mode() -> bool:
    """判斷是否為 Debug 模式

    Returns:
        bool: 是否為 Debug 模式
    """

    return bool(os.environ.get("DEBUG_MODE"))


def debug_print(message: str):
    """在 Debug 模式下輸出訊息

    Args:
        message (str): 要輸出的訊息
    """

    if is_debug_mode():
        print(f"[DEBUG] {message}")