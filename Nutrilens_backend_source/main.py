from fastapi import FastAPI
from database.db import db
from datetime import datetime


app = FastAPI()


@app.get("/")
async def test_db():
    try:
        # This forces connection
        collection_list = await db.list_collection_names()
        return {"status": "MongoDB connected", "list": collection_list}
    except Exception as e:
        return {"error": str(e)}
    


@app.get("/test-insert")
async def test_insert():
    await db["test"].insert_one({
        "msg": "hello",
        "time": datetime.now()
    })
    # Fetch data
    test_data = await db["test"].find().to_list(100)
    # FIX ObjectId
    for item in data:
        item["_id"] = str(item["_id"])
    return {"msg": "Inserted successfully"} #, "collections": test_data}