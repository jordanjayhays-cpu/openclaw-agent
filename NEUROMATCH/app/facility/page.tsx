"use client";

import { useState } from "react";
import { Calendar, Clock, User, CheckCircle, XCircle, Upload, Building2, DollarSign, CalendarDays } from "lucide-react";

const mockAppointments = [
  { id: 1, patient: "María García", scanType: "MRI", date: "2026-04-22", time: "10:00", status: "pending" },
  { id: 2, patient: "Carlos Rodríguez", scanType: "CT", date: "2026-04-22", time: "11:30", status: "confirmed" },
  { id: 3, patient: "Ana Martínez", scanType: "MRI", date: "2026-04-22", time: "14:00", status: "pending" },
  { id: 4, patient: "Pedro Sánchez", scanType: "PET", date: "2026-04-23", time: "09:00", status: "confirmed" },
];

const mockCalendarDays = [
  { date: 20, available: false, booked: 0 },
  { date: 21, available: true, booked: 2 },
  { date: 22, available: true, booked: 4 },
  { date: 23, available: true, booked: 3 },
  { date: 24, available: true, booked: 5 },
  { date: 25, available: true, booked: 2 },
  { date: 26, available: false, booked: 0 },
  { date: 27, available: true, booked: 1 },
  { date: 28, available: true, booked: 4 },
  { date: 29, available: true, booked: 3 },
  { date: 30, available: true, booked: 5 },
];

export default function FacilityPage() {
  const [appointments, setAppointments] = useState(mockAppointments);
  const [uploadModal, setUploadModal] = useState<{ open: boolean; appointmentId: number | null }>({ open: false, appointmentId: null });
  const [uploadData, setUploadData] = useState({ file: "", findings: "" });

  const handleStatusChange = (id: number, status: "confirmed" | "declined") => {
    setAppointments(appointments.map(apt => apt.id === id ? { ...apt, status } : apt));
  };

  const handleUpload = () => {
    setUploadModal({ open: false, appointmentId: null });
    setUploadData({ file: "", findings: "" });
  };

  const pendingCount = appointments.filter(a => a.status === "pending").length;
  const confirmedCount = appointments.filter(a => a.status === "confirmed").length;

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900">Facility Dashboard</h1>
          <p className="text-gray-600 mt-1">Centro de Diagnóstico Madrid Norte</p>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
          <div className="bg-white rounded-xl p-5 border border-gray-100">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-yellow-100 rounded-lg flex items-center justify-center">
                <Clock className="w-5 h-5 text-yellow-600" />
              </div>
              <div>
                <p className="text-2xl font-bold text-gray-900">{pendingCount}</p>
                <p className="text-sm text-gray-500">Pending</p>
              </div>
            </div>
          </div>
          <div className="bg-white rounded-xl p-5 border border-gray-100">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-green-100 rounded-lg flex items-center justify-center">
                <CheckCircle className="w-5 h-5 text-green-600" />
              </div>
              <div>
                <p className="text-2xl font-bold text-gray-900">{confirmedCount}</p>
                <p className="text-sm text-gray-500">Confirmed</p>
              </div>
            </div>
          </div>
          <div className="bg-white rounded-xl p-5 border border-gray-100">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center">
                <CalendarDays className="w-5 h-5 text-blue-600" />
              </div>
              <div>
                <p className="text-2xl font-bold text-gray-900">8</p>
                <p className="text-sm text-gray-500">This Week</p>
              </div>
            </div>
          </div>
          <div className="bg-white rounded-xl p-5 border border-gray-100">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-primary-100 rounded-lg flex items-center justify-center">
                <DollarSign className="w-5 h-5 text-primary-600" />
              </div>
              <div>
                <p className="text-2xl font-bold text-gray-900">€2,450</p>
                <p className="text-sm text-gray-500">Revenue</p>
              </div>
            </div>
          </div>
        </div>

        <div className="grid lg:grid-cols-3 gap-8">
          {/* Appointments */}
          <div className="lg:col-span-2">
            <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
              <h2 className="text-xl font-semibold text-gray-900 mb-6">Appointment Requests</h2>
              <div className="space-y-4">
                {appointments.map((apt) => (
                  <div key={apt.id} className="p-4 bg-gray-50 rounded-xl">
                    <div className="flex items-center justify-between mb-3">
                      <div className="flex items-center gap-3">
                        <div className="w-10 h-10 bg-primary-100 rounded-full flex items-center justify-center">
                          <User className="w-5 h-5 text-primary-600" />
                        </div>
                        <div>
                          <p className="font-medium text-gray-900">{apt.patient}</p>
                          <p className="text-sm text-gray-500">{apt.scanType} Scan</p>
                        </div>
                      </div>
                      <span className={`px-3 py-1 rounded-full text-sm font-medium ${
                        apt.status === "confirmed" ? "bg-green-100 text-green-700" :
                        apt.status === "declined" ? "bg-red-100 text-red-700" :
                        "bg-yellow-100 text-yellow-700"
                      }`}>
                        {apt.status === "pending" ? "Pending" : apt.status === "confirmed" ? "Confirmed" : "Declined"}
                      </span>
                    </div>
                    <div className="flex items-center gap-4 text-sm text-gray-600 mb-3">
                      <span className="flex items-center gap-1">
                        <Calendar className="w-4 h-4" />
                        {apt.date}
                      </span>
                      <span className="flex items-center gap-1">
                        <Clock className="w-4 h-4" />
                        {apt.time}
                      </span>
                    </div>
                    {apt.status === "pending" && (
                      <div className="flex gap-2">
                        <button
                          onClick={() => handleStatusChange(apt.id, "confirmed")}
                          className="flex-1 flex items-center justify-center gap-2 bg-green-600 text-white py-2 rounded-lg text-sm font-medium hover:bg-green-700 transition"
                        >
                          <CheckCircle className="w-4 h-4" />
                          Accept
                        </button>
                        <button
                          onClick={() => handleStatusChange(apt.id, "declined")}
                          className="flex-1 flex items-center justify-center gap-2 bg-red-600 text-white py-2 rounded-lg text-sm font-medium hover:bg-red-700 transition"
                        >
                          <XCircle className="w-4 h-4" />
                          Decline
                        </button>
                      </div>
                    )}
                    {apt.status === "confirmed" && (
                      <button
                        onClick={() => setUploadModal({ open: true, appointmentId: apt.id })}
                        className="w-full flex items-center justify-center gap-2 bg-primary-600 text-white py-2 rounded-lg text-sm font-medium hover:bg-primary-700 transition"
                      >
                        <Upload className="w-4 h-4" />
                        Upload Scan Results
                      </button>
                    )}
                  </div>
                ))}
              </div>
            </div>
          </div>

          {/* Calendar */}
          <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
            <h2 className="text-xl font-semibold text-gray-900 mb-6">Availability Calendar</h2>
            <div className="grid grid-cols-7 gap-1 mb-2">
              {["S", "M", "T", "W", "T", "F", "S"].map((day, i) => (
                <div key={i} className="text-center text-xs font-medium text-gray-500 py-2">{day}</div>
              ))}
            </div>
            <div className="grid grid-cols-7 gap-1">
              {mockCalendarDays.map((day, i) => (
                <button
                  key={i}
                  disabled={!day.available}
                  className={`aspect-square rounded-lg flex items-center justify-center text-sm font-medium transition ${
                    !day.available ? "text-gray-300 cursor-not-allowed" :
                    day.booked >= 5 ? "bg-red-100 text-red-700" :
                    day.booked >= 3 ? "bg-yellow-100 text-yellow-700" :
                    "bg-green-100 text-green-700 hover:bg-green-200"
                  }`}
                >
                  {day.date}
                </button>
              ))}
            </div>
            <div className="mt-4 space-y-2 text-sm">
              <div className="flex items-center gap-2">
                <div className="w-4 h-4 bg-green-100 rounded"></div>
                <span className="text-gray-600">Available (1-2 slots)</span>
              </div>
              <div className="flex items-center gap-2">
                <div className="w-4 h-4 bg-yellow-100 rounded"></div>
                <span className="text-gray-600">Filling up (3-4 slots)</span>
              </div>
              <div className="flex items-center gap-2">
                <div className="w-4 h-4 bg-red-100 rounded"></div>
                <span className="text-gray-600">Almost full (5 slots)</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Upload Modal */}
      {uploadModal.open && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
          <div className="bg-white rounded-2xl p-6 w-full max-w-md mx-4">
            <h3 className="text-lg font-semibold text-gray-900 mb-4">Upload Scan Results</h3>
            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Scan File (DICOM)</label>
                <div className="border-2 border-dashed border-gray-300 rounded-lg p-6 text-center">
                  <Upload className="w-8 h-8 text-gray-400 mx-auto mb-2" />
                  <p className="text-sm text-gray-500">Drag and drop or click to upload</p>
                </div>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Findings Summary</label>
                <textarea
                  rows={4}
                  value={uploadData.findings}
                  onChange={(e) => setUploadData({ ...uploadData, findings: e.target.value })}
                  className="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                  placeholder="Enter initial findings..."
                />
              </div>
              <div className="flex gap-3">
                <button
                  onClick={handleUpload}
                  className="flex-1 bg-primary-600 text-white py-2 rounded-lg font-medium hover:bg-primary-700 transition"
                >
                  Upload & Send to Radiologist
                </button>
                <button
                  onClick={() => setUploadModal({ open: false, appointmentId: null })}
                  className="px-4 py-2 border border-gray-300 rounded-lg font-medium text-gray-700 hover:bg-gray-50 transition"
                >
                  Cancel
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
