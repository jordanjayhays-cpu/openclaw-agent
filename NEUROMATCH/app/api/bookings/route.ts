import { NextRequest, NextResponse } from "next/server";

// Mock data - in production, use a database
let bookings: Booking[] = [
  {
    id: "1",
    patientName: "María García",
    email: "maria.garcia@email.com",
    phone: "+34 600 123 456",
    scanType: "MRI",
    location: "Madrid",
    preferredDate: "2026-04-22",
    status: "confirmed",
    createdAt: "2026-04-15T10:00:00Z",
  },
  {
    id: "2",
    patientName: "Carlos Rodríguez",
    email: "carlos.rodriguez@email.com",
    phone: "+34 600 234 567",
    scanType: "CT",
    location: "Barcelona",
    preferredDate: "2026-04-25",
    status: "pending",
    createdAt: "2026-04-16T14:30:00Z",
  },
];

interface Booking {
  id: string;
  patientName: string;
  email: string;
  phone: string;
  scanType: string;
  location: string;
  preferredDate: string;
  status: "pending" | "confirmed" | "declined" | "completed";
  createdAt: string;
}

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const status = searchParams.get("status");
  const location = searchParams.get("location");

  let filteredBookings = [...bookings];

  if (status) {
    filteredBookings = filteredBookings.filter((b) => b.status === status);
  }

  if (location) {
    filteredBookings = filteredBookings.filter((b) => b.location.toLowerCase() === location.toLowerCase());
  }

  return NextResponse.json({
    success: true,
    data: filteredBookings,
    total: filteredBookings.length,
  });
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();

    const { patientName, email, phone, scanType, location, preferredDate, symptoms } = body;

    // Validation
    if (!patientName || !email || !phone || !scanType || !location || !preferredDate) {
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

    // Create new booking
    const newBooking: Booking = {
      id: Date.now().toString(),
      patientName,
      email,
      phone,
      scanType,
      location,
      preferredDate,
      status: "pending",
      createdAt: new Date().toISOString(),
    };

    bookings.push(newBooking);

    return NextResponse.json(
      {
        success: true,
        data: newBooking,
        message: "Booking created successfully",
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
    const { id, status } = body;

    if (!id || !status) {
      return NextResponse.json(
        { success: false, error: "Missing id or status" },
        { status: 400 }
      );
    }

    const validStatuses = ["pending", "confirmed", "declined", "completed"];
    if (!validStatuses.includes(status)) {
      return NextResponse.json(
        { success: false, error: "Invalid status" },
        { status: 400 }
      );
    }

    const bookingIndex = bookings.findIndex((b) => b.id === id);
    if (bookingIndex === -1) {
      return NextResponse.json(
        { success: false, error: "Booking not found" },
        { status: 404 }
      );
    }

    bookings[bookingIndex].status = status;

    return NextResponse.json({
      success: true,
      data: bookings[bookingIndex],
      message: "Booking updated successfully",
    });
  } catch (error) {
    return NextResponse.json(
      { success: false, error: "Invalid request body" },
      { status: 400 }
    );
  }
}
