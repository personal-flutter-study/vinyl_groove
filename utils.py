"""
유틸리티 함수
"""
import re
from typing import Optional

def validate_email(email: str) -> bool:
    pattern = r'^[^@.]+@[^.@]+\.[^@.]+$'
    if not re.match(pattern, email):
        return False
    if email.index('@') < 2:
        return False
    return True

def validate_password_login(password: str) -> tuple[bool, Optional[str]]:
    if len(password) < 6:
        return False, "비밀번호는 6자 이상이어야 합니다."
    has_upper = any(c.isupper() for c in password)
    has_lower = any(c.islower() for c in password)
    if not (has_upper and has_lower):
        return False, "비밀번호는 대문자와 소문자를 각 1자 이상 포함해야 합니다."
    return True, None

def validate_password_signup(password: str) -> tuple[bool, Optional[str]]:
    if len(password) < 8:
        return False, "비밀번호는 8자 이상이어야 합니다."
    has_upper = any(c.isupper() for c in password)
    has_lower = any(c.islower() for c in password)
    has_digit = any(c.isdigit() for c in password)
    has_special = any(not c.isalnum() for c in password)
    if not (has_upper and has_lower and has_digit and has_special):
        return False, "비밀번호는 8자 이상, 대/소문자, 숫자, 특수문자를 각 1자 이상 포함해야 합니다."
    return True, None

def validate_name(name: str) -> bool:
    pattern = r'^[a-zA-Z가-힣\s]+$'
    return bool(re.match(pattern, name))

def validate_phone(phone: str) -> bool:
    pattern = r'^\d+-\d+-\d+$'
    return bool(re.match(pattern, phone))

def validate_barcode(barcode: str) -> bool:
    barcode = barcode.replace("-", "").replace(" ", "")
    return len(barcode) in [8, 13] and barcode.isdigit()

# 상수
GENRE_CODES = ["ROCK", "JAZZ", "POP", "HIPHOP", "ELECTRONIC", "CLASSICAL", "RNB_SOUL", "ETC"]
CONDITION_CODES = ["SS", "M", "NM", "EX", "VG+", "VG", "G"]
TRADE_METHOD_CODES = ["DIRECT", "DELIVERY", "BOTH"]
CONDITION_DESCRIPTIONS = {
    "SS": "미개봉 새상품. 완벽한 상태입니다.",
    "M": "Mint. 개봉했으나 새것과 다름없는 완벽한 상태입니다.",
    "NM": "Near Mint. 거의 새것에 가까운 상태로, 미세한 사용감만 있습니다.",
    "EX": "Excellent. 전체적으로 깨끗하며, 약간의 사용감이 있습니다.",
    "VG+": "Very Good Plus. 양호한 상태로, 재생에 문제가 없습니다.",
    "VG": "Very Good. 사용감이 있으나 재생에 큰 문제가 없습니다.",
    "G": "Good. 사용감이 많으나 재생은 가능합니다."
}
