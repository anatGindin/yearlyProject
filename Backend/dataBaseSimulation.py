from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List

app = FastAPI()

#class definitions
class Contact(BaseModel):
    fullName: str
    phoneNumber: str
class Mission(BaseModel):
    id: str
    location: str
    description: str
    contact: Contact
    time: str

'''
'''