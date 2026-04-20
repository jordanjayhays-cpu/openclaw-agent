"use client";

import { useState } from "react";
import { FileText, Clock, CheckCircle, DollarSign, User, Eye, Send, TrendingUp, AlertCircle } from "lucide-react";

const mockIncomingScans = [
  { id: 1, patient: "María García", scanType: "MRI", facility: "Centro Diagnóstico Madrid Norte", receivedAt: "2026-04-20 09:30", priority: "normal" },
  { id: 2, patient: "Carlos Rodríguez", scanType: "CT", facility: "Hospital Quirón Barcelona", receivedAt: "2026-04-20 08:15", priority: "urgent" },
  { id: 3, patient: "Ana Martínez", scanType: "MRI", facility: "Instituto Valenciano Neurociencias", receivedAt: "2026-04-19 16:45", priority: "normal" },
];

const mockCompletedReports = [
  { id: 1, patient: "Pedro Sánchez", scanType: "PET", facility: "Centro Médico Sevilla", completedAt: "2026-04-18", earnings: 150 },
  { id: 2, patient: "Laura López", scanType: "MRI", facility: "Centro Diagnóstico Madrid Norte", completedAt: "2026-04-17", earnings: 120 },
  { id: 3, patient: "Miguel Torres", scanType: "CT", facility: "Hospital Quirón Barcelona", completedAt: "2026-04-16", earnings: 100 },
];

export default function ProfessionalPage() {
  const [selectedScan, setSelectedScan] = useState<typeof mockIncomingScans[0] | null>(null);
  const [reportData, setReportData] = useState({ findings: "", impression: "", recommendations: "" });
  const [submitted, setSubmitted] = useState(false);

  const handleSubmitReport = (e: React.FormEvent) => {
    e.preventDefault();
    setSubmitted(true);
    setTimeout(() => {
      setSubmitted(false);
      setSelectedScan(null);
      setReportData({ findings: "", impression: "", recommendations: "" });
    }, 2000);
  };

  const pendingScans = mockIncomingScans.length;
  const thisMonthReports = mockCompletedReports.length;
  const thisMonthEarnings = mockCompletedReports.reduce((sum, r) => sum + r.earnings, 0);

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900">Radiologist Portal</h1>
          <p className="text-gray-600 mt-1">Dr. Elena Navarro - License #RAD-ES-2847</p>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
          <div className="bg-white rounded-xl p-5 border border-gray-100">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-yellow-100 rounded-lg flex items-center justify-center">
                <Clock className="w-5 h-5 text-yellow-600" />
              </div>
              <div>
                <p className="text-2xl font-bold text-gray-900">{pendingScans}</p>
                <p className="text-sm text-gray-500">Pending Review</p>
              </div>
            </div>
          </div>
          <div className="bg-white rounded-xl p-5 border border-gray-100">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-green-100 rounded-lg flex items-center justify-center">
                <CheckCircle className="w-5 h-5 text-green-600" />
              </div>
              <div>
                <p className="text-2xl font-bold text-gray-900">{thisMonthReports}</p>
                <p className="text-sm text-gray-500">Reports This Month</p>
              </div>
            </div>
          </div>
          <div className="bg-white rounded-xl p-5 border border-gray-100">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-primary-100 rounded-lg flex items-center justify-center">
                <DollarSign className="w-5 h-5 text-primary-600" />
              </div>
              <div>
                <p className="text-2xl font-bold text-gray-900">€{thisMonthEarnings}</p>
                <p className="text-sm text-gray-500">This Month</p>
              </div>
            </div>
          </div>
          <div className="bg-white rounded-xl p-5 border border-gray-100">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center">
                <TrendingUp className="w-5 h-5 text-blue-600" />
              </div>
              <div>
                <p className="text-2xl font-bold text-gray-900">€14,200</p>
                <p className="text-sm text-gray-500">Total Earnings</p>
              </div>
            </div>
          </div>
        </div>

        <div className="grid lg:grid-cols-3 gap-8">
          {/* Incoming Scans */}
          <div className="lg:col-span-2">
            <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
              <h2 className="text-xl font-semibold text-gray-900 mb-6 flex items-center gap-2">
                <Eye className="w-5 h-5 text-primary-600" />
                Scans to Interpret
              </h2>
              <div className="space-y-4">
                {mockIncomingScans.map((scan) => (
                  <div
                    key={scan.id}
                    className={`p-4 rounded-xl border-2 transition cursor-pointer ${
                      selectedScan?.id === scan.id ? "border-primary-500 bg-primary-50" : "border-gray-100 bg-gray-50 hover:border-gray-200"
                    }`}
                    onClick={() => setSelectedScan(scan)}
                  >
                    <div className="flex items-center justify-between">
                      <div className="flex items-center gap-3">
                        <div className={`w-12 h-12 rounded-xl flex items-center justify-center ${scan.scanType === 'MRI' ? 'bg-blue-100' : 'bg-teal-100'}`}>
                          <span className="font-bold text-gray-900 text-sm">{scan.scanType}</span>
                        </div>
                        <div>
                          <p className="font-medium text-gray-900">{scan.patient}</p>
                          <p className="text-sm text-gray-500">{scan.facility}</p>
                        </div>
                      </div>
                      <div className="text-right">
                        <span className={`inline-flex items-center gap-1 px-2 py-1 rounded-full text-xs font-medium ${
                          scan.priority === "urgent" ? "bg-red-100 text-red-700" : "bg-gray-100 text-gray-600"
                        }`}>
                          {scan.priority === "urgent" && <AlertCircle className="w-3 h-3" />}
                          {scan.priority.charAt(0).toUpperCase() + scan.priority.slice(1)}
                        </span>
                        <p className="text-xs text-gray-500 mt-1">{scan.receivedAt}</p>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>

          {/* Submit Report Form */}
          <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
            <h2 className="text-xl font-semibold text-gray-900 mb-6 flex items-center gap-2">
              <FileText className="w-5 h-5 text-medical-600" />
              Submit Report
            </h2>
            
            {selectedScan ? (
              submitted ? (
                <div className="text-center py-8">
                  <CheckCircle className="w-16 h-16 text-green-500 mx-auto mb-4" />
                  <h3 className="text-lg font-semibold text-gray-900 mb-2">Report Submitted!</h3>
                  <p className="text-gray-600 text-sm">Payment will be processed within 24 hours.</p>
                </div>
              ) : (
                <form onSubmit={handleSubmitReport} className="space-y-4">
                  <div className="p-4 bg-gray-50 rounded-xl">
                    <p className="text-sm text-gray-500">Patient</p>
                    <p className="font-medium text-gray-900">{selectedScan.patient}</p>
                    <p className="text-sm text-gray-600 mt-1">{selectedScan.scanType} - {selectedScan.facility}</p>
                  </div>

                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1">Clinical Findings</label>
                    <textarea
                      rows={4}
                      required
                      value={reportData.findings}
                      onChange={(e) => setReportData({ ...reportData, findings: e.target.value })}
                      className="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-primary-500 focus:border-transparent text-sm"
                      placeholder="Describe the findings in detail..."
                    />
                  </div>

                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1">Impression</label>
                    <textarea
                      rows={2}
                      required
                      value={reportData.impression}
                      onChange={(e) => setReportData({ ...reportData, impression: e.target.value })}
                      className="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-primary-500 focus:border-transparent text-sm"
                      placeholder="Summary impression..."
                    />
                  </div>

                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1">Recommendations</label>
                    <textarea
                      rows={2}
                      value={reportData.recommendations}
                      onChange={(e) => setReportData({ ...reportData, recommendations: e.target.value })}
                      className="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-primary-500 focus:border-transparent text-sm"
                      placeholder="Any follow-up recommendations..."
                    />
                  </div>

                  <button
                    type="submit"
                    className="w-full flex items-center justify-center gap-2 bg-gradient-to-r from-primary-600 to-medical-500 text-white py-3 rounded-lg font-semibold hover:opacity-90 transition"
                  >
                    <Send className="w-4 h-4" />
                    Submit Report
                  </button>
                </form>
              )
            ) : (
              <div className="text-center py-12 text-gray-500">
                <FileText className="w-12 h-12 mx-auto mb-3 opacity-50" />
                <p>Select a scan to interpret</p>
              </div>
            )}
          </div>
        </div>

        {/* Earnings History */}
        <div className="mt-8 bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
          <h2 className="text-xl font-semibold text-gray-900 mb-6">Recent Completed Reports</h2>
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="text-left text-sm text-gray-500 border-b border-gray-100">
                  <th className="pb-3 font-medium">Patient</th>
                  <th className="pb-3 font-medium">Scan Type</th>
                  <th className="pb-3 font-medium">Facility</th>
                  <th className="pb-3 font-medium">Completed</th>
                  <th className="pb-3 font-medium text-right">Earnings</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {mockCompletedReports.map((report) => (
                  <tr key={report.id} className="text-sm">
                    <td className="py-3 font-medium text-gray-900">{report.patient}</td>
                    <td className="py-3 text-gray-600">{report.scanType}</td>
                    <td className="py-3 text-gray-600">{report.facility}</td>
                    <td className="py-3 text-gray-600">{report.completedAt}</td>
                    <td className="py-3 text-right font-medium text-green-600">€{report.earnings}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
}
