import { NextRequest, NextResponse } from "next/server";

// Mock data - in production, use a database
let professionals: Professional[] = [
  {
    id: "1",
    name: "Dr. Elena Navarro",
    email: "e.navarro@neuromatch.es",
    phone: "+34 600 111 222",
    license: "RAD-ES-2847",
    specialty: "Neuroradiology",
    city: "Madrid",
    rating: 4.9,
    reportsCompleted: 523,
    available: true,
    hourlyRate: 120,
    createdAt: "2025-01-10T10:00:00Z",
  },
  {
    id: "2",
    name: "Dr. Alejandro Vidal",
    email: "a.vidal@neuromatch.es",
    phone: "+34 600 222 333",
    license: "RAD-ES-3456",
    specialty: "Diagnostic Radiology",
    city: "Barcelona",
    rating: 4.8,
    reportsCompleted: 412,
    available: true,
    hourlyRate: 110,
    createdAt: "2025-02-15T10:00:00Z",
  },
  {
    id: "3",
    name: "Dra. Carmen Ruiz",
    email: "c.ruiz@neuromatch.es",
    phone: "+34 600 333 444",
    license: "RAD-ES-4567",
    specialty: "Neuroradiology",
    city: "Valencia",
    rating: 4.7,
    reportsCompleted: 389,
    available: true,
    hourlyRate: 115,
    createdAt: "2025-03-01T10:00:00Z",
  },
  {
    id: "4",
    name: "Dr. Pablo Moreno",
    email: "p.moreno@neuromatch.es",
    phone: "+34 600 444 555",
    license: "RAD-ES-5678",
    specialty: "Nuclear Medicine",
    city: "Sevilla",
    rating: 4.8,
    reportsCompleted: 298,
    available: false,
    hourlyRate: 130,
    createdAt: "2025-03-20T10:00:00Z",
  },
];

interface Professional {
  id: string;
  name: string;
  email: string;
  phone: string;
  license: string;
  specialty: string;
  city: string;
  rating: number;
  reportsCompleted: number;
  available: boolean;
  hourlyRate: number;
  createdAt: string;
}

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const city = searchParams.get("city");
  const specialty = searchParams.get("specialty");
  const available = searchParams.get("available");

  let filteredProfessionals = [...professionals];

  if (city) {
    filteredProfessionals = filteredProfessionals.filter(
      (p) => p.city.toLowerCase() === city.toLowerCase()
    );
  }

  if (specialty) {
    filteredProfessionals = filteredProfessionals.filter(
      (p) => p.specialty.toLowerCase() === specialty.toLowerCase()
    );
  }

  if (available === "true") {
    filteredProfessionals = filteredProfessionals.filter((p) => p.available);
  }

  return NextResponse.json({
    success: true,
    data: filteredProfessionals,
    total: filteredProfessionals.length,
  });
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();

    const { name, email, phone, license, specialty, city, hourlyRate } = body;

    // Validation
    if (!name || !email || !phone || !license || !specialty || !city) {
      return NextResponse.json(
        { success: false, error: "Missing required fields" },
        { status: 400 }
      );
    }

    // Email validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return NextResponse.json(
        { success: false, error: "Invalid email format" },
        { status: 400 }
      );
    }

    // Create new professional
    const newProfessional: Professional = {
      id: Date.now().toString(),
      name,
      email,
      phone,
      license,
      specialty,
      city,
      rating: 0,
      reportsCompleted: 0,
      available: true,
      hourlyRate: hourlyRate || 100,
      createdAt: new Date().toISOString(),
    };

    professionals.push(newProfessional);

    return NextResponse.json(
      {
        success: true,
        data: newProfessional,
        message: "Professional registered successfully",
      },
      { status: 201 }
    );
  } catch (error) {
    return NextResponse.json(
      { success: false, error: "Invalid request body" },
      { status: 400 }
    );
  }
}

export async function PATCH(request: NextRequest) {
  try {
    const body = await request.json();
    const { id, available } = body;

    if (!id || available === undefined) {
      return NextResponse.json(
        { success: false, error: "Missing id or availability status" },
        { status: 400 }
      );
    }

    const professionalIndex = professionals.findIndex((p) => p.id === id);
    if (professionalIndex === -1) {
      return NextResponse.json(
        { success: false, error: "Professional not found" },
        { status: 404 }
      );
    }

    professionals[professionalIndex].available = available;

    return NextResponse.json({
      success: true,
      data: professionals[professionalIndex],
      message: "Professional availability updated successfully",
    });
  } catch (error) {
    return NextResponse.json(
      { success: false, error: "Invalid request body" },
      { status: 400 }
    );
  }
}
