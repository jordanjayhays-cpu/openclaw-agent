"use client";

import Link from "next/link";
import { useState } from "react";
import { Brain, Menu, X } from "lucide-react";

export default function Navigation() {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <header className="sticky top-0 z-50 bg-white/95 backdrop-blur-sm border-b border-gray-100">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center h-16">
          <Link href="/" className="flex items-center gap-2">
            <div className="w-10 h-10 bg-gradient-to-br from-medical-500 to-primary-600 rounded-xl flex items-center justify-center">
              <Brain className="w-6 h-6 text-white" />
            </div>
            <span className="text-xl font-bold text-gray-900">NeuroMatch</span>
          </Link>

          <nav className="hidden md:flex items-center gap-8">
            <Link href="/patient" className="text-gray-600 hover:text-primary-600 font-medium transition">
              Patient Portal
            </Link>
            <Link href="/facility" className="text-gray-600 hover:text-primary-600 font-medium transition">
              Facility Portal
            </Link>
            <Link href="/professional" className="text-gray-600 hover:text-primary-600 font-medium transition">
              Radiologists
            </Link>
            <Link href="/admin" className="text-gray-600 hover:text-primary-600 font-medium transition">
              Admin
            </Link>
          </nav>

          <button
            onClick={() => setIsOpen(!isOpen)}
            className="md:hidden p-2 text-gray-600"
          >
            {isOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
          </button>
        </div>
      </div>

      {isOpen && (
        <div className="md:hidden bg-white border-t border-gray-100">
          <nav className="px-4 py-4 space-y-3">
            <Link href="/patient" className="block py-2 text-gray-600 hover:text-primary-600 font-medium">
              Patient Portal
            </Link>
            <Link href="/facility" className="block py-2 text-gray-600 hover:text-primary-600 font-medium">
              Facility Portal
            </Link>
            <Link href="/professional" className="block py-2 text-gray-600 hover:text-primary-600 font-medium">
              Radiologists
            </Link>
            <Link href="/admin" className="block py-2 text-gray-600 hover:text-primary-600 font-medium">
              Admin
            </Link>
          </nav>
        </div>
      )}
    </header>
  );
}
