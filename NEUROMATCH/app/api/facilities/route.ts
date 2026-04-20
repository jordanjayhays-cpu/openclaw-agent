import { NextRequest, NextResponse } from "next/server";

// Mock data - in production, use a database
let facilities: Facility[] = [
  {
    id: "1",
    name: "Centro de Diagnóstico Madrid Norte",
    address: "Calle Serrano 245, Madrid",
    city: "Madrid",
    phone: "+34 900 111 222",
    email: "madridnorte@centrodiagnostico.es",
    rating: 4.8,
    reviews: 234,
    available: true,
    scanTypes: ["MRI", "CT", "PET"],
    priceRange: { min: 200, max: 1200 },
    coordinates: { lat: 40.4637, lng: -3.7492 },
    workingHours: "Mon-Fri: 8:00-20:00, Sat: 9:00-14:00",
    createdAt: "2025-01-15T10:00:00Z",
  },
  {
    id: "2",
    name: "Hospital Quirón Barcelona",
    address: "Av. Diagonal 488, Barcelona",
    city: "Barcelona",
    phone: "+34 900 222 333",
    email: "barcelona@quironsalud.es",
    rating: 4.9,
    reviews: 567,
    available: true,
    scanTypes: ["MRI", "CT", "PET"],
    priceRange: { min: 180, max: 1100 },
    coordinates: { lat: 41.3851, lng: 2.1734 },
    workingHours: "Mon-Fri: 7:00-21:00, Sat: 8:00-15:00",
    createdAt: "2025-02-20T10:00:00Z",
  },
  {
    id: "3",
    name: "Instituto Valenciano de Neurociencias",
    address: "C/ Colón 78, Valencia",
    city: "Valencia",
    phone: "+34 900 333 444",
    email: "info@ivneuro.es",
    rating: 4.7,
    reviews: 189,
    available: false,
    scanTypes: ["MRI", "CT"],
    priceRange: { min: 220, max: 900 },
    coordinates: { lat: 39.4699, lng: -0.3763 },
    workingHours: "Mon-Fri: 8:30-19:00",
    createdAt: "2025-03-10T10:00:00Z",
  },
  {
    id: "4",
    name: "Centro Médico Sevilla Imaging",
    address: "Av. Luis Montoto 100, Sevilla",
    city: "Sevilla",
    phone: "+34 900 444 555",
    email: "sevilla@cmi.es",
    rating: 4.6,
    reviews: 145,
    available: true,
    scanTypes: ["MRI", "CT", "PET"],
    priceRange: { min: 190, max: 1050 },
    coordinates: { lat: 37.3891, lng: -5.9845 },
    workingHours: "Mon-Fri: 8:00-20:00, Sat: 9:00-13:00",
    createdAt: "2025-04-05T10:00:00Z",
  },
];

interface Facility {
  id: string;
  name: string;
  address: string;
  city: string;
  phone: string;
  email: string;
  rating: number;
  reviews: number;
  available: boolean;
  scanTypes: string[];
  priceRange: { min: number; max: number };
  coordinates: { lat: number; lng: number };
  workingHours: string;
  createdAt: string;
}

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const city = searchParams.get("city");
  const scanType = searchParams.get("scanType");
  const available = searchParams.get("available");

  let filteredFacilities = [...facilities];

  if (city) {
    filteredFacilities = filteredFacilities.filter(
      (f) => f.city.toLowerCase() === city.toLowerCase()
    );
  }

  if (scanType) {
    filteredFacilities = filteredFacilities.filter((f) =>
      f.scanTypes.includes(scanType.toUpperCase())
    );
  }

  if (available === "true") {
    filteredFacilities = filteredFacilities.filter((f) => f.available);
  }

  return NextResponse.json({
    success: true,
    data: filteredFacilities,
    total: filteredFacilities.length,
  });
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();

    const { name, address, city, phone, email, scanTypes } = body;

    // Validation
    if (!name || !address || !city || !phone || !email) {
      return NextResponse.json(
        { success: false, error: "Missing required fields" },
        { status: 400 }
      );
    }

    // Create new facility
    const newFacility: Facility = {
      id: Date.now().toString(),
      name,
      address,
      city,
      phone,
      email,
      rating: 0,
      reviews: 0,
      available: true,
      scanTypes: scanTypes || ["MRI", "CT"],
      priceRange: { min: 200, max: 1000 },
      coordinates: { lat: 0, lng: 0 },
      workingHours: "Mon-Fri: 8:00-18:00",
      createdAt: new Date().toISOString(),
    };

    facilities.push(newFacility);

    return NextResponse.json(
      {
        success: true,
        data: newFacility,
        message: "Facility created successfully",
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
