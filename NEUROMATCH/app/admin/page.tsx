"use client";

import { useState } from "react";
import { Building2, Users, Calendar, DollarSign, TrendingUp, Activity, BarChart3, Globe, Download } from "lucide-react";

const mockStats = {
  totalBookings: 15234,
  totalRevenue: 4582000,
  activeFacilities: 52,
  activeProfessionals: 203,
  monthlyBookings: 1247,
  monthlyGrowth: 12.5,
};

const mockFacilities = [
  { name: "Centro Diagnóstico Madrid Norte", city: "Madrid", bookings: 234, revenue: 70200, status: "active" },
  { name: "Hospital Quirón Barcelona", city: "Barcelona", bookings: 189, revenue: 56700, status: "active" },
  { name: "Instituto Valenciano Neurociencias", city: "Valencia", bookings: 156, revenue: 46800, status: "active" },
  { name: "Centro Médico Sevilla Imaging", city: "Sevilla", bookings: 145, revenue: 43500, status: "active" },
  { name: "Clínica Bilbao Radiología", city: "Bilbao", bookings: 98, revenue: 29400, status: "inactive" },
];

const mockProfessionals = [
  { name: "Dr. Elena Navarro", specialty: "Neuroradiology", reportsCompleted: 89, earnings: 10680 },
  { name: "Dr. Alejandro Vidal", specialty: "Diagnostic Radiology", reportsCompleted: 76, earnings: 9120 },
  { name: "Dra. Carmen Ruiz", specialty: "Neuroradiology", reportsCompleted: 68, earnings: 8160 },
  { name: "Dr. Pablo Moreno", specialty: "Nuclear Medicine", reportsCompleted: 54, earnings: 7560 },
];

const mockCommissions = [
  { month: "Jan 2026", bookings: 1102, revenue: 330600, commission: 16530 },
  { month: "Feb 2026", bookings: 1189, revenue: 356700, commission: 17835 },
  { month: "Mar 2026", bookings: 1247, revenue: 374100, commission: 18705 },
];

export default function AdminPage() {
  const [activeTab, setActiveTab] = useState<"overview" | "facilities" | "professionals" | "commissions">("overview");

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat("es-ES", { style: "currency", currency: "EUR" }).format(amount);
  };

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="flex items-center justify-between mb-8">
          <div>
            <h1 className="text-3xl font-bold text-gray-900">Admin Dashboard</h1>
            <p className="text-gray-600 mt-1">NeuroMatch Platform Management</p>
          </div>
          <button className="flex items-center gap-2 bg-primary-600 text-white px-4 py-2 rounded-lg font-medium hover:bg-primary-700 transition">
            <Download className="w-4 h-4" />
            Export Report
          </button>
        </div>

        {/* Stats Grid */}
        <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-4 mb-8">
          <div className="bg-white rounded-xl p-4 border border-gray-100">
            <div className="flex items-center gap-2 mb-2">
              <Calendar className="w-5 h-5 text-primary-600" />
              <span className="text-sm text-gray-500">Total Bookings</span>
            </div>
            <p className="text-2xl font-bold text-gray-900">{mockStats.totalBookings.toLocaleString()}</p>
          </div>
          <div className="bg-white rounded-xl p-4 border border-gray-100">
            <div className="flex items-center gap-2 mb-2">
              <DollarSign className="w-5 h-5 text-green-600" />
              <span className="text-sm text-gray-500">Total Revenue</span>
            </div>
            <p className="text-2xl font-bold text-gray-900">€{(mockStats.totalRevenue / 1000).toFixed(0)}k</p>
          </div>
          <div className="bg-white rounded-xl p-4 border border-gray-100">
            <div className="flex items-center gap-2 mb-2">
              <Building2 className="w-5 h-5 text-teal-600" />
              <span className="text-sm text-gray-500">Facilities</span>
            </div>
            <p className="text-2xl font-bold text-gray-900">{mockStats.activeFacilities}</p>
          </div>
          <div className="bg-white rounded-xl p-4 border border-gray-100">
            <div className="flex items-center gap-2 mb-2">
              <Users className="w-5 h-5 text-purple-600" />
              <span className="text-sm text-gray-500">Professionals</span>
            </div>
            <p className="text-2xl font-bold text-gray-900">{mockStats.activeProfessionals}</p>
          </div>
          <div className="bg-white rounded-xl p-4 border border-gray-100">
            <div className="flex items-center gap-2 mb-2">
              <Activity className="w-5 h-5 text-yellow-600" />
              <span className="text-sm text-gray-500">Monthly Bookings</span>
            </div>
            <p className="text-2xl font-bold text-gray-900">{mockStats.monthlyBookings}</p>
          </div>
          <div className="bg-white rounded-xl p-4 border border-gray-100">
            <div className="flex items-center gap-2 mb-2">
              <TrendingUp className="w-5 h-5 text-blue-600" />
              <span className="text-sm text-gray-500">Growth</span>
            </div>
            <p className="text-2xl font-bold text-gray-900">+{mockStats.monthlyGrowth}%</p>
          </div>
        </div>

        {/* Tabs */}
        <div className="flex gap-2 mb-6 border-b border-gray-200">
          {[
            { id: "overview", label: "Overview", icon: BarChart3 },
            { id: "facilities", label: "Facilities", icon: Building2 },
            { id: "professionals", label: "Professionals", icon: Users },
            { id: "commissions", label: "Commissions", icon: DollarSign },
          ].map((tab) => (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id as typeof activeTab)}
              className={`flex items-center gap-2 px-4 py-3 font-medium transition border-b-2 ${
                activeTab === tab.id
                  ? "border-primary-600 text-primary-600"
                  : "border-transparent text-gray-500 hover:text-gray-700"
              }`}
            >
              <tab.icon className="w-4 h-4" />
              {tab.label}
            </button>
          ))}
        </div>

        {/* Overview Tab */}
        {activeTab === "overview" && (
          <div className="grid lg:grid-cols-2 gap-8">
            <div className="bg-white rounded-2xl p-6 border border-gray-100">
              <h2 className="text-lg font-semibold text-gray-900 mb-4">Revenue Overview</h2>
              <div className="space-y-4">
                <div className="flex items-end justify-between">
                  <span className="text-gray-600">Total Platform Revenue</span>
                  <span className="text-2xl font-bold text-gray-900">€4,582,000</span>
                </div>
                <div className="h-2 bg-gray-100 rounded-full overflow-hidden">
                  <div className="h-full bg-gradient-to-r from-primary-500 to-medical-500 rounded-full" style={{ width: "78%" }}></div>
                </div>
                <div className="flex justify-between text-sm text-gray-500">
                  <span>Commission: €229,100 (5%)</span>
                  <span>78% utilization</span>
                </div>
              </div>
            </div>

            <div className="bg-white rounded-2xl p-6 border border-gray-100">
              <h2 className="text-lg font-semibold text-gray-900 mb-4">Network Growth</h2>
              <div className="grid grid-cols-2 gap-4">
                <div className="p-4 bg-green-50 rounded-xl">
                  <p className="text-sm text-green-600 font-medium">New Facilities (30d)</p>
                  <p className="text-xl font-bold text-gray-900">+4</p>
                </div>
                <div className="p-4 bg-blue-50 rounded-xl">
                  <p className="text-sm text-blue-600 font-medium">New Professionals (30d)</p>
                  <p className="text-xl font-bold text-gray-900">+12</p>
                </div>
                <div className="p-4 bg-purple-50 rounded-xl">
                  <p className="text-sm text-purple-600 font-medium">Avg. Report Time</p>
                  <p className="text-xl font-bold text-gray-900">38.5h</p>
                </div>
                <div className="p-4 bg-yellow-50 rounded-xl">
                  <p className="text-sm text-yellow-600 font-medium">Patient Satisfaction</p>
                  <p className="text-xl font-bold text-gray-900">4.8/5</p>
                </div>
              </div>
            </div>
          </div>
        )}

        {/* Facilities Tab */}
        {activeTab === "facilities" && (
          <div className="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
            <div className="p-6 border-b border-gray-100 flex items-center justify-between">
              <h2 className="text-lg font-semibold text-gray-900">All Facilities</h2>
              <button className="bg-primary-600 text-white px-4 py-2 rounded-lg text-sm font-medium hover:bg-primary-700 transition">
                Add Facility
              </button>
            </div>
            <div className="overflow-x-auto">
              <table className="w-full">
                <thead>
                  <tr className="text-left text-sm text-gray-500 bg-gray-50">
                    <th className="px-6 py-3 font-medium">Facility</th>
                    <th className="px-6 py-3 font-medium">City</th>
                    <th className="px-6 py-3 font-medium">Bookings</th>
                    <th className="px-6 py-3 font-medium">Revenue</th>
                    <th className="px-6 py-3 font-medium">Status</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-100">
                  {mockFacilities.map((facility, index) => (
                    <tr key={index} className="text-sm">
                      <td className="px-6 py-4 font-medium text-gray-900">{facility.name}</td>
                      <td className="px-6 py-4 text-gray-600">{facility.city}</td>
                      <td className="px-6 py-4 text-gray-600">{facility.bookings}</td>
                      <td className="px-6 py-4 text-gray-900">{formatCurrency(facility.revenue)}</td>
                      <td className="px-6 py-4">
                        <span className={`inline-flex items-center px-2 py-1 rounded-full text-xs font-medium ${
                          facility.status === "active" ? "bg-green-100 text-green-700" : "bg-gray-100 text-gray-600"
                        }`}>
                          {facility.status.charAt(0).toUpperCase() + facility.status.slice(1)}
                        </span>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        )}

        {/* Professionals Tab */}
        {activeTab === "professionals" && (
          <div className="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
            <div className="p-6 border-b border-gray-100 flex items-center justify-between">
              <h2 className="text-lg font-semibold text-gray-900">All Professionals</h2>
              <button className="bg-primary-600 text-white px-4 py-2 rounded-lg text-sm font-medium hover:bg-primary-700 transition">
                Add Professional
              </button>
            </div>
            <div className="overflow-x-auto">
              <table className="w-full">
                <thead>
                  <tr className="text-left text-sm text-gray-500 bg-gray-50">
                    <th className="px-6 py-3 font-medium">Name</th>
                    <th className="px-6 py-3 font-medium">Specialty</th>
                    <th className="px-6 py-3 font-medium">Reports Completed</th>
                    <th className="px-6 py-3 font-medium">Total Earnings</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-100">
                  {mockProfessionals.map((prof, index) => (
                    <tr key={index} className="text-sm">
                      <td className="px-6 py-4 font-medium text-gray-900">{prof.name}</td>
                      <td className="px-6 py-4 text-gray-600">{prof.specialty}</td>
                      <td className="px-6 py-4 text-gray-600">{prof.reportsCompleted}</td>
                      <td className="px-6 py-4 text-green-600 font-medium">{formatCurrency(prof.earnings)}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        )}

        {/* Commissions Tab */}
        {activeTab === "commissions" && (
          <div className="space-y-6">
            <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
              <h2 className="text-lg font-semibold text-gray-900 mb-4">Commission Tracker (5% platform fee)</h2>
              <div className="overflow-x-auto">
                <table className="w-full">
                  <thead>
                    <tr className="text-left text-sm text-gray-500 border-b border-gray-100">
                      <th className="pb-3 font-medium">Month</th>
                      <th className="pb-3 font-medium">Total Bookings</th>
                      <th className="pb-3 font-medium">Platform Revenue</th>
                      <th className="pb-3 font-medium text-right">Commission Earned</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-100">
                    {mockCommissions.map((item, index) => (
                      <tr key={index} className="text-sm">
                        <td className="py-3 font-medium text-gray-900">{item.month}</td>
                        <td className="py-3 text-gray-600">{item.bookings}</td>
                        <td className="py-3 text-gray-600">{formatCurrency(item.revenue)}</td>
                        <td className="py-3 text-right font-medium text-green-600">{formatCurrency(item.commission)}</td>
                      </tr>
                    ))}
                    <tr className="bg-gray-50 font-semibold">
                      <td className="py-3 text-gray-900">Total</td>
                      <td className="py-3 text-gray-900">3,538</td>
                      <td className="py-3 text-gray-900">{formatCurrency(1061400)}</td>
                      <td className="py-3 text-right text-green-600">{formatCurrency(53070)}</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>

            <div className="grid md:grid-cols-3 gap-4">
              <div className="bg-gradient-to-br from-primary-600 to-primary-700 rounded-2xl p-6 text-white">
                <p className="text-primary-100 mb-1">Total Commission (YTD)</p>
                <p className="text-3xl font-bold">€53,070</p>
              </div>
              <div className="bg-gradient-to-br from-medical-600 to-medical-700 rounded-2xl p-6 text-white">
                <p className="text-medical-100 mb-1">Average per Month</p>
                <p className="text-3xl font-bold">€17,690</p>
              </div>
              <div className="bg-gradient-to-br from-green-600 to-green-700 rounded-2xl p-6 text-white">
                <p className="text-green-100 mb-1">Projected Annual</p>
                <p className="text-3xl font-bold">€212,280</p>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
