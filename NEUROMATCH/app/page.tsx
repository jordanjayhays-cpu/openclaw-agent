"use client";

import { useState } from "react";
import Link from "next/link";
import { Calendar, Clock, CheckCircle, MapPin, Phone, Star, ChevronRight, Scan, Building2, Users, FileText } from "lucide-react";

const scanTypes = [
  {
    type: "MRI",
    name: "Magnetic Resonance Imaging",
    description: "Detailed soft tissue images using magnetic fields",
    duration: "30-60 min",
    price: "€350-€600",
    color: "bg-blue-500",
  },
  {
    type: "CT",
    name: "Computed Tomography",
    description: "Cross-sectional X-ray images for bone and tissue",
    duration: "10-20 min",
    price: "€200-€400",
    color: "bg-teal-500",
  },
  {
    type: "PET",
    name: "Positron Emission Tomography",
    description: "Metabolic activity imaging for early detection",
    duration: "60-90 min",
    price: "€800-€1200",
    color: "bg-purple-500",
  },
];

const facilities = [
  {
    name: "Centro de Diagnóstico Madrid Norte",
    address: "Calle Serrano 245, Madrid",
    rating: 4.8,
    reviews: 234,
    distance: "2.3 km",
    available: true,
  },
  {
    name: "Hospital Quirón Barcelona",
    address: "Av. Diagonal 488, Barcelona",
    rating: 4.9,
    reviews: 567,
    distance: "5.1 km",
    available: true,
  },
  {
    name: "Instituto Valenciano de Neurociencias",
    address: "C/ Colón 78, Valencia",
    rating: 4.7,
    reviews: 189,
    distance: "8.4 km",
    available: false,
  },
  {
    name: "Centro Médico Sevilla Imaging",
    address: "Av. Luis Montoto 100, Sevilla",
    rating: 4.6,
    reviews: 145,
    distance: "12.7 km",
    available: true,
  },
];

export default function HomePage() {
  const [formData, setFormData] = useState({
    name: "",
    email: "",
    phone: "",
    scanType: "MRI",
    location: "Madrid",
  });
  const [submitted, setSubmitted] = useState(false);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setSubmitted(true);
    setTimeout(() => setSubmitted(false), 3000);
  };

  return (
    <div className="flex flex-col">
      {/* Hero Section */}
      <section className="relative bg-gradient-to-br from-medical-50 via-white to-primary-50 py-20 lg:py-32">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid lg:grid-cols-2 gap-12 items-center">
            <div>
              <div className="inline-flex items-center gap-2 bg-primary-100 text-primary-700 px-4 py-2 rounded-full text-sm font-medium mb-6">
                <Scan className="w-4 h-4" />
                Spain's Premier Brain Scan Network
              </div>
              <h1 className="text-4xl lg:text-6xl font-extrabold text-gray-900 leading-tight mb-6">
                Brain Scans.
                <br />
                <span className="text-transparent bg-clip-text bg-gradient-to-r from-primary-600 to-medical-500">
                  Fast.
                </span>
              </h1>
              <p className="text-xl text-gray-600 mb-8 max-w-lg">
                Book certified MRI, CT, and PET scans at trusted facilities near you.
                Results delivered to your doctor within 48 hours.
              </p>
              <div className="flex flex-wrap gap-4">
                <Link
                  href="/patient"
                  className="inline-flex items-center gap-2 bg-primary-600 text-white px-6 py-3 rounded-xl font-semibold hover:bg-primary-700 transition"
                >
                  Book a Scan
                  <ChevronRight className="w-5 h-5" />
                </Link>
                <a
                  href="#how-it-works"
                  className="inline-flex items-center gap-2 bg-white text-gray-700 px-6 py-3 rounded-xl font-semibold border border-gray-200 hover:border-gray-300 transition"
                >
                  How It Works
                </a>
              </div>
            </div>

            {/* Booking Form */}
            <div className="bg-white rounded-2xl shadow-xl p-6 lg:p-8 border border-gray-100">
              <h2 className="text-2xl font-bold text-gray-900 mb-6">Book Your Scan</h2>
              {submitted ? (
                <div className="text-center py-8">
                  <CheckCircle className="w-16 h-16 text-green-500 mx-auto mb-4" />
                  <h3 className="text-xl font-semibold text-gray-900 mb-2">Request Received!</h3>
                  <p className="text-gray-600">We'll contact you within 2 hours to confirm your appointment.</p>
                </div>
              ) : (
                <form onSubmit={handleSubmit} className="space-y-4">
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1">Full Name</label>
                    <input
                      type="text"
                      required
                      value={formData.name}
                      onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                      className="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                      placeholder="María García"
                    />
                  </div>
                  <div className="grid grid-cols-2 gap-4">
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">Email</label>
                      <input
                        type="email"
                        required
                        value={formData.email}
                        onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                        className="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                        placeholder="maria@email.com"
                      />
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">Phone</label>
                      <input
                        type="tel"
                        required
                        value={formData.phone}
                        onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                        className="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                        placeholder="+34 600 123 456"
                      />
                    </div>
                  </div>
                  <div className="grid grid-cols-2 gap-4">
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">Scan Type</label>
                      <select
                        value={formData.scanType}
                        onChange={(e) => setFormData({ ...formData, scanType: e.target.value })}
                        className="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                      >
                        <option value="MRI">MRI</option>
                        <option value="CT">CT Scan</option>
                        <option value="PET">PET Scan</option>
                      </select>
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">City</label>
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
                    Request Appointment
                  </button>
                  <p className="text-xs text-gray-500 text-center">
                    By submitting, you agree to our Terms of Service and Privacy Policy.
                  </p>
                </form>
              )}
            </div>
          </div>
        </div>
      </section>

      {/* How It Works */}
      <section id="how-it-works" className="py-20 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl lg:text-4xl font-bold text-gray-900 mb-4">How It Works</h2>
            <p className="text-xl text-gray-600 max-w-2xl mx-auto">
              Three simple steps to get your brain scan done quickly and efficiently.
            </p>
          </div>

          <div className="grid md:grid-cols-3 gap-8">
            <div className="text-center p-6">
              <div className="w-16 h-16 bg-primary-100 rounded-2xl flex items-center justify-center mx-auto mb-6">
                <Calendar className="w-8 h-8 text-primary-600" />
              </div>
              <div className="inline-flex items-center justify-center w-8 h-8 bg-gray-900 text-white rounded-full text-sm font-bold mb-4">
                1
              </div>
              <h3 className="text-xl font-semibold text-gray-900 mb-3">Book Online</h3>
              <p className="text-gray-600">
                Select your scan type, preferred location, and schedule. We'll match you with certified facilities.
              </p>
            </div>

            <div className="text-center p-6">
              <div className="w-16 h-16 bg-medical-100 rounded-2xl flex items-center justify-center mx-auto mb-6">
                <Building2 className="w-8 h-8 text-medical-600" />
              </div>
              <div className="inline-flex items-center justify-center w-8 h-8 bg-gray-900 text-white rounded-full text-sm font-bold mb-4">
                2
              </div>
              <h3 className="text-xl font-semibold text-gray-900 mb-3">Visit Facility</h3>
              <p className="text-gray-600">
                Show up at your chosen facility at the scheduled time. Our partner centers are equipped with state-of-the-art scanners.
              </p>
            </div>

            <div className="text-center p-6">
              <div className="w-16 h-16 bg-green-100 rounded-2xl flex items-center justify-center mx-auto mb-6">
                <FileText className="w-8 h-8 text-green-600" />
              </div>
              <div className="inline-flex items-center justify-center w-8 h-8 bg-gray-900 text-white rounded-full text-sm font-bold mb-4">
                3
              </div>
              <h3 className="text-xl font-semibold text-gray-900 mb-3">Get Results</h3>
              <p className="text-gray-600">
                Receive your scan results within 48 hours. Your doctor will get a detailed report from our certified radiologists.
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* Scan Types */}
      <section className="py-20 bg-gray-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl lg:text-4xl font-bold text-gray-900 mb-4">Scan Types</h2>
            <p className="text-xl text-gray-600 max-w-2xl mx-auto">
              Choose the right imaging for your needs. All scans performed by certified technicians.
            </p>
          </div>

          <div className="grid md:grid-cols-3 gap-8">
            {scanTypes.map((scan) => (
              <div key={scan.type} className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 hover:shadow-lg transition">
                <div className={`w-14 h-14 ${scan.color} rounded-xl flex items-center justify-center mb-4`}>
                  <Scan className="w-7 h-7 text-white" />
                </div>
                <h3 className="text-2xl font-bold text-gray-900 mb-1">{scan.type}</h3>
                <p className="text-gray-600 mb-4">{scan.name}</p>
                <p className="text-gray-500 text-sm mb-4">{scan.description}</p>
                <div className="flex items-center justify-between pt-4 border-t border-gray-100">
                  <div className="flex items-center gap-1 text-gray-600 text-sm">
                    <Clock className="w-4 h-4" />
                    {scan.duration}
                  </div>
                  <span className="font-semibold text-gray-900">{scan.price}</span>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Facilities Near You */}
      <section className="py-20 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl lg:text-4xl font-bold text-gray-900 mb-4">Facilities Near You</h2>
            <p className="text-xl text-gray-600 max-w-2xl mx-auto">
              Certified imaging centers across Spain, all equipped with modern technology.
            </p>
          </div>

          <div className="grid md:grid-cols-2 gap-6">
            {facilities.map((facility, index) => (
              <div key={index} className="bg-white rounded-2xl p-6 border border-gray-200 hover:border-primary-200 hover:shadow-md transition">
                <div className="flex justify-between items-start mb-3">
                  <h3 className="text-lg font-semibold text-gray-900">{facility.name}</h3>
                  <span className={`inline-flex items-center gap-1 px-2 py-1 rounded-full text-xs font-medium ${facility.available ? 'bg-green-100 text-green-700' : 'bg-gray-100 text-gray-600'}`}>
                    {facility.available ? 'Available' : 'Fully Booked'}
                  </span>
                </div>
                <div className="flex items-center gap-2 text-gray-500 text-sm mb-3">
                  <MapPin className="w-4 h-4" />
                  {facility.address}
                </div>
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-1">
                    <Star className="w-4 h-4 text-yellow-400 fill-current" />
                    <span className="font-medium text-gray-900">{facility.rating}</span>
                    <span className="text-gray-500 text-sm">({facility.reviews} reviews)</span>
                  </div>
                  <span className="text-sm text-gray-500">{facility.distance}</span>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Stats Section */}
      <section className="py-20 bg-gradient-to-r from-primary-600 to-medical-600">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid grid-cols-2 md:grid-cols-4 gap-8 text-center">
            <div>
              <div className="text-4xl lg:text-5xl font-bold text-white mb-2">50+</div>
              <div className="text-primary-100">Certified Facilities</div>
            </div>
            <div>
              <div className="text-4xl lg:text-5xl font-bold text-white mb-2">200+</div>
              <div className="text-primary-100">Expert Radiologists</div>
            </div>
            <div>
              <div className="text-4xl lg:text-5xl font-bold text-white mb-2">15k+</div>
              <div className="text-primary-100">Scans Completed</div>
            </div>
            <div>
              <div className="text-4xl lg:text-5xl font-bold text-white mb-2">48h</div>
              <div className="text-primary-100">Average Report Time</div>
            </div>
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-20 bg-gray-900">
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h2 className="text-3xl lg:text-4xl font-bold text-white mb-4">
            Ready to Book Your Brain Scan?
          </h2>
          <p className="text-xl text-gray-400 mb-8 max-w-2xl mx-auto">
            Get scanned at a certified facility near you. Results in 48 hours, delivered to your doctor.
          </p>
          <Link
            href="/patient"
            className="inline-flex items-center gap-2 bg-white text-gray-900 px-8 py-4 rounded-xl font-semibold hover:bg-gray-100 transition"
          >
            Book a Scan Now
            <ChevronRight className="w-5 h-5" />
          </Link>
        </div>
      </section>
    </div>
  );
}
