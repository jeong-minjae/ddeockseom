from fastapi import APIRouter, HTTPException, status
from pydantic import BaseModel

from db import connect, hash_password, normalize_gender, verify_password

router = APIRouter()


class UserLoginRequest(BaseModel):
    email: str
    password: str


def _get_user(cursor, email: str):
    cursor.execute(
        "SELECT userid, useremail, userpassword, userage, usersex FROM `user` WHERE useremail = %s",
        (email,),
    )
    return cursor.fetchone()


@router.post("/login")
def login(data: UserLoginRequest):
    email = data.email.strip().lower()

    conn = connect()
    try:
        with conn.cursor() as cursor:
            user = _get_user(cursor, email)

        if not user or not verify_password(data.password, user["userpassword"]):
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid email or password.",
            )

        return {
            "message": "Login successful.",
            "data": {
                "userid": user["userid"],
                "useremail": user["useremail"],
                "userage": user["userage"],
                "usersex": user["usersex"],
            },
        }
    finally:
        conn.close()
