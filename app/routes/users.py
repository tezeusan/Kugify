from typing import Annotated

from fastapi import APIRouter, Depends
from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncSession

from app.database import get_db

router = APIRouter()


@router.get("/ping-db")
async def ping_db(session: Annotated[AsyncSession, Depends(get_db)]):
    result = await session.execute(text("SELECT 'hello world from postgres'"))
    return {"result": result.scalar()}
