"use client";

import { useState } from "react";
import { Calendar, Clock, MapPin, CheckCircle, AlertCircle, FileText, User } from "lucide-react";

const mockBookings = [
  { id: 1, scanType: "MRI", facility: "Centro de Diagnóstico Madrid Norte", date: "2026-04-22", time: "10:00", status: "confirmed" },
  { id: 2, scanType: "CT", facility: "Hospital Quirón Barcelona", date: "2026-04-25", time: "14:30", status: "pending" },
];

const mockResults = [
  { id: 1, scanType: "MRI", date: "2026-04-10", facility: "Centro de Diagnóstico Madrid Norte", report: "No abnormalities detected. All structures within normal limits.", downloadUrl: "#" },
];

export default function PatientPage() {
  const [formData, setFormData] = useState({
    name: "María García",
    email: "maria.garcia@email.com",
    phone: "+34 600 123 456",
    symptoms: "",
    scanType: "MRI",
    location: "Madrid",
    preferredDate: "",
  });
  const [submitted, setSubmitted] = useState(false);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setSubmitted(true);
    setTimeout(() => setSubmitted(false), 3000);
  };

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900">Patient Dashboard</h1>
          <p className="text-gray-600 mt-1">Manage your brain scan appointments and view results.</p>
        </div>

        <div className="grid lg:grid-cols-3 gap-8">
          {/* Booking Form */}
          <div className="lg:col-span-2">
            <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-6 mb-8">
              <h2 className="text-xl font-semibold text-gray-900 mb-6 flex items-center gap-2">
                <Calendar className="w-5 h-5 text-primary-600" />
                Book a New Scan
              </h2>
              
              {submitted ? (
                <div className="text-center py-8 bg-green-50 rounded-xl">
                  <CheckCircle className="w-16 h-16 text-green-500 mx-auto mb-4" />
                  <h3 className="text-xl font-semibold text-gray-900 mb-2">Booking Request Sent!</h3>
                  <p className="text-gray-600">We'll confirm your appointment via email within 2 hours.</p>
                </div>
              ) : (
                <form onSubmit={handleSubmit} className="space-y-5">
                  <div className="grid md:grid-cols-2 gap-5">
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">Full Name</label>
                      <input
                        type="text"
                        required
                        value={formData.name}
                        onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                        className="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                      />
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">Email</label>
                      <input
                        type="email"
                        required
                        value={formData.email}
                        onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                        className="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                      />
                    </div>
                  </div>

                  <div className="grid md:grid-cols-2 gap-5">
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">Phone</label>
                      <input
                        type="tel"
                        required
                        value={formData.phone}
                        onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                        className="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                      />
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">Preferred Date</label>
                      <input
                        type="date"
                        required
                        value={formData.preferredDate}
                        onChange={(e) => setFormData({ ...formData, preferredDate: e.target.value })}
                        className="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                      />
                    </div>
                  </div>

                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1">Symptoms / Reason for Scan</label>
                    <textarea
                      rows={3}
                      value={formData.symptoms}
                      onChange={(e) => setFormData({ ...formData, symptoms: e.target.value })}
                      className="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                      placeholder="Describe your symptoms or reason for the scan..."
                    />
                  </div>

                  <div className="grid md:grid-cols-2 gap-5">
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">Scan Type</label>
                      <select
                        value={formData.scanType}
                        onChange={(e) => setFormData({ ...formData, scanType: e.target.value })}
                        className="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                      >
                        <option value="MRI">MRI - Magnetic Resonance Imaging</option>
                        <option value="CT">CT - Computed Tomography</option>
                        <option value="PET">PET - Positron Emission Tomography</option>
                      </select>
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">Nearest City</label>
                      <select
                        value={formData.location}
                        onChange={(e) => setFormData({ ...formData, location: e.target.value })}
                        className="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                      >
                        <option value="Madrid">Madrid</option>
                        <option value="Barcelona">Barcelona</option>
                        <option value="Valencia">Valencia</option>
                        <option value="Sevilla">Sevilla</option>
                      </select>
                    </div>
                  </div>

                  <button
                    type="submit"
                    className="w-full bg-gradient-to-r from-primary-600 to-medical-500 text-white py-3 rounded-lg font-semibold hover:opacity-90 transition"
                  >
                    Submit Booking Request
                  </button>
                </form>
              )}
            </div>

            {/* My Bookings */}
            <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
              <h2 className="text-xl font-semibold text-gray-900 mb-6">My Bookings</h2>
              <div className="space-y-4">
                {mockBookings.map((booking) => (
                  <div key={booking.id} className="flex items-center justify-between p-4 bg-gray-50 rounded-xl">
                    <div className="flex items-center gap-4">
                      <div className={`w-12 h-12 rounded-xl flex items-center justify-center ${booking.scanType === 'MRI' ? 'bg-blue-100' : 'bg-teal-100'}`}>
                        <span className="font-bold text-gray-900 text-sm">{booking.scanType}</span>
                      </div>
                      <div>
                        <p className="font-medium text-gray-900">{booking.facility}</p>
                        <div className="flex items-center gap-3 text-sm text-gray-500 mt-1">
                          <span className="flex items-center gap-1">
                            <Calendar className="w-3 h-3" />
                            {booking.date}
                          </span>
                          <span className="flex items-center gap-1">
                            <Clock className="w-3 h-3" />
                            {booking.time}
                          </span>
                        </div>
                      </div>
                    </div>
                    <span className={`px-3 py-1 rounded-full text-sm font-medium ${booking.status === 'confirmed' ? 'bg-green-100 text-green-700' : 'bg-yellow-100 text-yellow-700'}`}>
                      {booking.status === 'confirmed' ? 'Confirmed' : 'Pending'}
                    </span>
                  </div>
                ))}
              </div>
            </div>
          </div>

          {/* Sidebar */}
          <div className="space-y-6">
            {/* Profile Card */}
            <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
              <h2 className="text-lg font-semibold text-gray-900 mb-4">Patient Profile</h2>
              <div className="flex items-center gap-4 mb-4">
                <div className="w-14 h-14 bg-primary-100 rounded-full flex items-center justify-center">
                  <User className="w-7 h-7 text-primary-600" />
                </div>
                <div>
                  <p className="font-semibold text-gray-900">{formData.name}</p>
                  <p className="text-sm text-gray-500">Patient ID: NM-2026-001</p>
                </div>
              </div>
              <div className="space-y-2 text-sm">
                <p className="text-gray-600">{formData.email}</p>
                <p className="text-gray-600">{formData.phone}</p>
              </div>
            </div>

            {/* My Results */}
            <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
              <h2 className="text-lg font-semibold text-gray-900 mb-4 flex items-center gap-2">
                <FileText className="w-5 h-5 text-medical-600" />
                My Results
              </h2>
              {mockResults.length > 0 ? (
                <div className="space-y-4">
                  {mockResults.map((result) => (
                    <div key={result.id} className="p-4 bg-gray-50 rounded-xl">
                      <div className="flex items-center justify-between mb-2">
                        <span className="font-medium text-gray-900">{result.scanType}</span>
                        <span className="text-sm text-gray-500">{result.date}</span>
                      </div>
                      <p className="text-sm text-gray-600 mb-3">{result.facility}</p>
                      <div className="bg-white p-3 rounded-lg border border-gray-200 mb-3">
                        <p className="text-xs text-gray-500 mb-1">Report Summary:</p>
                        <p className="text-sm text-gray-700">{result.report}</p>
                      </div>
                      <a href={result.downloadUrl} className="block w-full text-center bg-primary-600 text-white py-2 rounded-lg text-sm font-medium hover:bg-primary-700 transition">
                        Download Full Report
                      </a>
                    </div>
                  ))}
                </div>
              ) : (
                <div className="text-center py-6 text-gray-500">
                  <AlertCircle className="w-10 h-10 mx-auto mb-2 opacity-50" />
                  <p>No results available yet</p>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
