from pydantic import BaseModel

class Contact(BaseModel):
    fullName: str
    phoneNumber: str

class Mission(BaseModel):
    id: str
    location: str
    description: str
    contact: Contact
    time: str
    status: str
