import Link from "next/link";
import { Brain } from "lucide-react";

export default function Footer() {
  return (
    <footer className="bg-gray-900 text-gray-300">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
          <div className="col-span-1 md:col-span-2">
            <div className="flex items-center gap-2 mb-4">
              <div className="w-10 h-10 bg-gradient-to-br from-medical-500 to-primary-600 rounded-xl flex items-center justify-center">
                <Brain className="w-6 h-6 text-white" />
              </div>
              <span className="text-xl font-bold text-white">NeuroMatch</span>
            </div>
            <p className="text-gray-400 max-w-md">
              Connecting patients with certified brain scan facilities across Spain.
              Fast, reliable, and secure diagnostic imaging services.
            </p>
          </div>

          <div>
            <h3 className="text-white font-semibold mb-4">Quick Links</h3>
            <ul className="space-y-2">
              <li><Link href="/patient" className="hover:text-white transition">Book a Scan</Link></li>
              <li><Link href="/facility" className="hover:text-white transition">For Facilities</Link></li>
              <li><Link href="/professional" className="hover:text-white transition">For Radiologists</Link></li>
              <li><Link href="/admin" className="hover:text-white transition">Admin Panel</Link></li>
            </ul>
          </div>

          <div>
            <h3 className="text-white font-semibold mb-4">Contact</h3>
            <ul className="space-y-2 text-gray-400">
              <li>contact@neuromatch.com</li>
              <li>+34 900 123 456</li>
              <li>Madrid, Spain</li>
            </ul>
          </div>
        </div>

        <div className="border-t border-gray-800 mt-8 pt-8 text-center text-gray-500">
          <p>&copy; {new Date().getFullYear()} NeuroMatch. All rights reserved.</p>
        </div>
      </div>
    </footer>
  );
}
