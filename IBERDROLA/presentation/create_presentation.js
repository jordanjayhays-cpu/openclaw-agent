const PptxGenJS = require('pptxgenjs');
const pptx = new PptxGenJS();

// Set presentation properties
pptx.author = 'IE Business School Datathon Team';
pptx.title = 'Strategic Placement of EV Charging Infrastructure for Iberdrola';
pptx.subject = 'EV Charging Strategy - EU 2030 Requirements';
pptx.company = 'Iberdrola Datathon 2026';

// Color scheme - Iberdrola theme
const COLORS = {
  iberdrolaGreen: '00974C',
  darkBg: '0D0D1A',
  accent: '00D864',
  yellow: 'FFD700',
  red: 'FF3B30',
  white: 'FFFFFF',
  lightGray: 'CCCCCC'
};

// Fonts
pptx.defineLayout({ name: 'LAYOUT_16x9', width: 13.33, height: 7.5 });
pptx.layout = 'LAYOUT_16x9';

// ============ SLIDE 1: TITLE ============
let slide1 = pptx.addSlide();
slide1.background = { color: COLORS.darkBg };

// Iberdrola branding
slide1.addText('IBERDROLA', {
  x: 0.5, y: 0.4, w: 3, h: 0.5,
  fontSize: 18, bold: true, color: COLORS.accent,
  fontFace: 'Arial'
});

slide1.addText('Datathon 2026', {
  x: 10, y: 0.4, w: 2.5, h: 0.4,
  fontSize: 12, color: COLORS.lightGray,
  fontFace: 'Arial', align: 'right'
});

// Main title
slide1.addText('Strategic Placement of EV Charging Infrastructure', {
  x: 0.5, y: 2.2, w: 12.33, h: 1.2,
  fontSize: 42, bold: true, color: COLORS.white,
  fontFace: 'Arial', align: 'center'
});

slide1.addText('Meeting EU 2030 Requirements Through Data-Driven Analysis', {
  x: 0.5, y: 3.5, w: 12.33, h: 0.6,
  fontSize: 22, color: COLORS.accent,
  fontFace: 'Arial', align: 'center'
});

slide1.addText('April 21, 2026', {
  x: 0.5, y: 6.5, w: 12.33, h: 0.4,
  fontSize: 14, color: COLORS.lightGray,
  fontFace: 'Arial', align: 'center'
});

// ============ SLIDE 2: THE PROBLEM ============
let slide2 = pptx.addSlide();
slide2.background = { color: COLORS.darkBg };

slide2.addText('The Challenge', {
  x: 0.5, y: 0.3, w: 12.33, h: 0.8,
  fontSize: 38, bold: true, color: COLORS.white,
  fontFace: 'Arial', align: 'center'
});

slide2.addText("Spain's Charging Infrastructure Gap", {
  x: 0.5, y: 1.0, w: 12.33, h: 0.5,
  fontSize: 18, color: COLORS.accent,
  fontFace: 'Arial', align: 'center'
});

// EU Target box
slide2.addShape(pptx.ShapeType.roundRect, {
  x: 0.5, y: 1.8, w: 3.8, h: 2.2,
  fill: { color: '1a3d1a' },
  line: { color: COLORS.accent, width: 2 }
});
slide2.addText('420,000', {
  x: 0.5, y: 1.9, w: 3.8, h: 1.2,
  fontSize: 48, bold: true, color: COLORS.accent,
  fontFace: 'Arial', align: 'center'
});
slide2.addText('Public chargers required\nby EU by 2030', {
  x: 0.5, y: 3.1, w: 3.8, h: 0.8,
  fontSize: 12, color: COLORS.white,
  fontFace: 'Arial', align: 'center'
});

// Current Spain box
slide2.addShape(pptx.ShapeType.roundRect, {
  x: 4.7, y: 1.8, w: 3.8, h: 2.2,
  fill: { color: '3d3d1a' },
  line: { color: COLORS.yellow, width: 2 }
});
slide2.addText('~50,000', {
  x: 4.7, y: 1.9, w: 3.8, h: 1.2,
  fontSize: 48, bold: true, color: COLORS.yellow,
  fontFace: 'Arial', align: 'center'
});
slide2.addText('Currently installed\nin Spain', {
  x: 4.7, y: 3.1, w: 3.8, h: 0.8,
  fontSize: 12, color: COLORS.white,
  fontFace: 'Arial', align: 'center'
});

// Gap box
slide2.addShape(pptx.ShapeType.roundRect, {
  x: 8.9, y: 1.8, w: 3.8, h: 2.2,
  fill: { color: '3d1a1a' },
  line: { color: COLORS.red, width: 2 }
});
slide2.addText('370,000', {
  x: 8.9, y: 1.9, w: 3.8, h: 1.2,
  fontSize: 48, bold: true, color: COLORS.red,
  fontFace: 'Arial', align: 'center'
});
slide2.addText('Gap to fill\n92,500/year needed', {
  x: 8.9, y: 3.1, w: 3.8, h: 0.8,
  fontSize: 12, color: COLORS.white,
  fontFace: 'Arial', align: 'center'
});

// 8x rate
slide2.addText('8x', {
  x: 0.5, y: 4.3, w: 2, h: 1,
  fontSize: 60, bold: true, color: COLORS.red,
  fontFace: 'Arial', align: 'center'
});
slide2.addText('Faster installation\nrate required', {
  x: 0.5, y: 5.2, w: 2, h: 0.6,
  fontSize: 12, color: COLORS.lightGray,
  fontFace: 'Arial', align: 'center'
});

// EV projection
slide2.addShape(pptx.ShapeType.roundRect, {
  x: 3, y: 4.3, w: 9.5, h: 1.5,
  fill: { color: '2a2a3d' }
});
slide2.addText('By 2027: Over 1.5 million EVs projected on Spanish roads', {
  x: 3, y: 4.7, w: 9.5, h: 0.6,
  fontSize: 18, color: COLORS.white,
  fontFace: 'Arial', align: 'center'
});

// ============ SLIDE 3: THE REALITY ============
let slide3 = pptx.addSlide();
slide3.background = { color: '1a0a0a' };

slide3.addText('The Reality', {
  x: 0.5, y: 0.3, w: 12.33, h: 0.8,
  fontSize: 38, bold: true, color: COLORS.white,
  fontFace: 'Arial', align: 'center'
});

slide3.addText('Infrastructure at Capacity', {
  x: 0.5, y: 1.0, w: 12.33, h: 0.5,
  fontSize: 18, color: COLORS.yellow,
  fontFace: 'Arial', align: 'center'
});

// Pie chart simulation with shapes
// 91.5% congested (red)
slide3.addShape(pptx.ShapeType.ellipse, {
  x: 0.8, y: 1.8, w: 3.5, h: 3.5,
  fill: { color: COLORS.red }
});
slide3.addText('91.5%', {
  x: 0.8, y: 2.8, w: 3.5, h: 0.8,
  fontSize: 36, bold: true, color: COLORS.white,
  fontFace: 'Arial', align: 'center'
});
slide3.addText('CONGESTED', {
  x: 0.8, y: 3.5, w: 3.5, h: 0.4,
  fontSize: 14, bold: true, color: COLORS.white,
  fontFace: 'Arial', align: 'center'
});

// Legend
slide3.addShape(pptx.ShapeType.rect, {
  x: 5, y: 2.0, w: 0.4, h: 0.4,
  fill: { color: COLORS.red }
});
slide3.addText('91.5% — Congested (574 stations)', {
  x: 5.6, y: 2.0, w: 4, h: 0.4,
  fontSize: 14, color: COLORS.white, fontFace: 'Arial'
});

slide3.addShape(pptx.ShapeType.rect, {
  x: 5, y: 2.6, w: 0.4, h: 0.4,
  fill: { color: COLORS.yellow }
});
slide3.addText('3.2% — Moderate capacity', {
  x: 5.6, y: 2.6, w: 4, h: 0.4,
  fontSize: 14, color: COLORS.white, fontFace: 'Arial'
});

slide3.addShape(pptx.ShapeType.rect, {
  x: 5, y: 3.2, w: 0.4, h: 0.4,
  fill: { color: COLORS.accent }
});
slide3.addText('5.3% — Available for expansion (33 stations)', {
  x: 5.6, y: 3.2, w: 4, h: 0.4,
  fontSize: 14, color: COLORS.white, fontFace: 'Arial'
});

// Customer voice box
slide3.addShape(pptx.ShapeType.roundRect, {
  x: 0.5, y: 5.5, w: 12.33, h: 1.5,
  fill: { color: '2a1a1a' }
});
slide3.addText('Customer Voice: 8,350 conversations analyzed', {
  x: 0.7, y: 5.6, w: 12, h: 0.4,
  fontSize: 14, bold: true, color: COLORS.yellow, fontFace: 'Arial'
});
slide3.addText('Top pain points: App/Digital (29.2% negative) | Pricing (25.8%) | Route Planning (27.5%) | Reliability (25.9%)', {
  x: 0.7, y: 6.1, w: 12, h: 0.4,
  fontSize: 12, color: COLORS.lightGray, fontFace: 'Arial'
});

// ============ SLIDE 4: OUR APPROACH ============
let slide4 = pptx.addSlide();
slide4.background = { color: '0a1a0a' };

slide4.addText('Our Methodology', {
  x: 0.5, y: 0.3, w: 12.33, h: 0.8,
  fontSize: 38, bold: true, color: COLORS.white,
  fontFace: 'Arial', align: 'center'
});

slide4.addText('Three-Pillar Analysis', {
  x: 0.5, y: 1.0, w: 12.33, h: 0.5,
  fontSize: 18, color: COLORS.accent,
  fontFace: 'Arial', align: 'center'
});

// Step 1
slide4.addShape(pptx.ShapeType.roundRect, {
  x: 0.5, y: 1.7, w: 4, h: 1.8,
  fill: { color: '1a3d1a' },
  line: { color: COLORS.accent, width: 0 }
});
slide4.addText('01', {
  x: 0.7, y: 1.8, w: 1, h: 0.6,
  fontSize: 28, bold: true, color: '00D864', fontFace: 'Arial'
});
slide4.addText('Network Analysis', {
  x: 0.7, y: 2.3, w: 3.6, h: 0.4,
  fontSize: 16, bold: true, color: COLORS.accent, fontFace: 'Arial'
});
slide4.addText('Analyzed 627 existing stations\nMapped grid capacity\nIdentified 403 friction points', {
  x: 0.7, y: 2.7, w: 3.6, h: 0.8,
  fontSize: 11, color: COLORS.lightGray, fontFace: 'Arial'
});

// Step 2
slide4.addShape(pptx.ShapeType.roundRect, {
  x: 4.7, y: 1.7, w: 4, h: 1.8,
  fill: { color: '1a3d1a' },
  line: { color: COLORS.accent, width: 0 }
});
slide4.addText('02', {
  x: 4.9, y: 1.8, w: 1, h: 0.6,
  fontSize: 28, bold: true, color: '00D864', fontFace: 'Arial'
});
slide4.addText('Customer Integration', {
  x: 4.9, y: 2.3, w: 3.6, h: 0.4,
  fontSize: 16, bold: true, color: COLORS.accent, fontFace: 'Arial'
});
slide4.addText('Synthesized 8,350 conversations\nIdentified 12 demand themes\nPrioritized reliability needs', {
  x: 4.9, y: 2.7, w: 3.6, h: 0.8,
  fontSize: 11, color: COLORS.lightGray, fontFace: 'Arial'
});

// Step 3
slide4.addShape(pptx.ShapeType.roundRect, {
  x: 8.9, y: 1.7, w: 4, h: 1.8,
  fill: { color: '1a3d1a' },
  line: { color: COLORS.accent, width: 0 }
});
slide4.addText('03', {
  x: 9.1, y: 1.8, w: 1, h: 0.6,
  fontSize: 28, bold: true, color: '00D864', fontFace: 'Arial'
});
slide4.addText('Optimization Model', {
  x: 9.1, y: 2.3, w: 3.6, h: 0.4,
  fontSize: 16, bold: true, color: COLORS.accent, fontFace: 'Arial'
});
slide4.addText('Built recommendation engine\nBalanced capacity + demand\nMaximized ROI', {
  x: 9.1, y: 2.7, w: 3.6, h: 0.8,
  fontSize: 11, color: COLORS.lightGray, fontFace: 'Arial'
});

// 568 stations highlight
slide4.addShape(pptx.ShapeType.roundRect, {
  x: 4.3, y: 4.0, w: 4.7, h: 2.5,
  fill: { color: '1a3d1a' }
});
slide4.addText('568', {
  x: 4.3, y: 4.2, w: 4.7, h: 1.2,
  fontSize: 72, bold: true, color: COLORS.accent,
  fontFace: 'Arial', align: 'center'
});
slide4.addText('New stations identified', {
  x: 4.3, y: 5.3, w: 4.7, h: 0.5,
  fontSize: 18, color: COLORS.white,
  fontFace: 'Arial', align: 'center'
});
slide4.addText('Not just where they fit — where they\'ll work', {
  x: 4.3, y: 5.8, w: 4.7, h: 0.4,
  fontSize: 12, color: COLORS.accent,
  fontFace: 'Arial', align: 'center'
});

// ============ SLIDE 5: THE SOLUTION ============
let slide5 = pptx.addSlide();
slide5.background = { color: COLORS.iberdrolaGreen };

slide5.addText('The Solution', {
  x: 0.5, y: 0.3, w: 12.33, h: 0.8,
  fontSize: 38, bold: true, color: COLORS.white,
  fontFace: 'Arial', align: 'center'
});

slide5.addText('Strategic Placement — Not More Building', {
  x: 0.5, y: 1.0, w: 12.33, h: 0.5,
  fontSize: 18, color: 'CCFFDD',
  fontFace: 'Arial', align: 'center'
});

// Checkmarks
const checks = [
  'Grid capacity available',
  'Demand proven by data',
  'Customer need identified',
  'Economic viability verified'
];

checks.forEach((text, i) => {
  slide5.addText('✓', {
    x: 1, y: 1.8 + i * 0.7, w: 0.6, h: 0.5,
    fontSize: 24, bold: true, color: COLORS.white, fontFace: 'Arial'
  });
  slide5.addText(text, {
    x: 1.7, y: 1.8 + i * 0.7, w: 5, h: 0.5,
    fontSize: 20, color: COLORS.white, fontFace: 'Arial'
  });
});

// +40% highlight
slide5.addShape(pptx.ShapeType.roundRect, {
  x: 7.5, y: 1.8, w: 5, h: 3,
  fill: { color: '007A3D' }
});
slide5.addText('+40%', {
  x: 7.5, y: 2.2, w: 5, h: 1.2,
  fontSize: 72, bold: true, color: COLORS.white,
  fontFace: 'Arial', align: 'center'
});
slide5.addText('Network capacity increase\nwithout new grid infrastructure', {
  x: 7.5, y: 3.5, w: 5, h: 0.8,
  fontSize: 14, color: 'CCFFDD',
  fontFace: 'Arial', align: 'center'
});

// ============ SLIDE 6: THE NUMBERS ============
let slide6 = pptx.addSlide();
slide6.background = { color: COLORS.darkBg };

slide6.addText('The Business Case', {
  x: 0.5, y: 0.3, w: 12.33, h: 0.8,
  fontSize: 38, bold: true, color: COLORS.white,
  fontFace: 'Arial', align: 'center'
});

slide6.addText('ROI That Pencils Out', {
  x: 0.5, y: 1.0, w: 12.33, h: 0.5,
  fontSize: 18, color: COLORS.accent,
  fontFace: 'Arial', align: 'center'
});

// Metric cards
const metrics = [
  { value: '1.9', label: 'Years Avg Payback', sub: '(with 30% EU grants)' },
  { value: '<12', label: 'Months Best Location', sub: 'Top performing sites', color: COLORS.yellow },
  { value: '6.8', label: 'Sessions/Charger/Day', sub: 'Industry: 5-12 benchmark' }
];

metrics.forEach((m, i) => {
  const x = 0.8 + i * 4.2;
  slide6.addShape(pptx.ShapeType.roundRect, {
    x: x, y: 1.7, w: 3.8, h: 2,
    fill: { color: '1a1a2e' }
  });
  slide6.addText(m.value, {
    x: x, y: 1.9, w: 3.8, h: 1,
    fontSize: 48, bold: true, color: m.color || COLORS.accent,
    fontFace: 'Arial', align: 'center'
  });
  slide6.addText(m.label, {
    x: x, y: 2.8, w: 3.8, h: 0.4,
    fontSize: 12, color: COLORS.white,
    fontFace: 'Arial', align: 'center'
  });
  slide6.addText(m.sub, {
    x: x, y: 3.2, w: 3.8, h: 0.3,
    fontSize: 10, color: COLORS.lightGray,
    fontFace: 'Arial', align: 'center'
  });
});

// Station counts
slide6.addText('2,878', {
  x: 1.5, y: 4.2, w: 2.5, h: 0.8,
  fontSize: 36, bold: true, color: COLORS.accent,
  fontFace: 'Arial', align: 'center'
});
slide6.addText('Existing', {
  x: 1.5, y: 4.9, w: 2.5, h: 0.3,
  fontSize: 12, color: COLORS.lightGray,
  fontFace: 'Arial', align: 'center'
});

slide6.addText('→', {
  x: 4, y: 4.3, w: 1, h: 0.6,
  fontSize: 36, color: COLORS.lightGray,
  fontFace: 'Arial', align: 'center'
});

slide6.addText('568', {
  x: 5, y: 4.2, w: 2.5, h: 0.8,
  fontSize: 36, bold: true, color: COLORS.yellow,
  fontFace: 'Arial', align: 'center'
});
slide6.addText('New Proposed', {
  x: 5, y: 4.9, w: 2.5, h: 0.3,
  fontSize: 12, color: COLORS.lightGray,
  fontFace: 'Arial', align: 'center'
});

slide6.addText('=', {
  x: 7.5, y: 4.3, w: 1, h: 0.6,
  fontSize: 36, color: COLORS.lightGray,
  fontFace: 'Arial', align: 'center'
});

slide6.addText('3,446', {
  x: 8.3, y: 4.2, w: 3, h: 0.8,
  fontSize: 36, bold: true, color: COLORS.white,
  fontFace: 'Arial', align: 'center'
});
slide6.addText('Total Network by 2028', {
  x: 8.3, y: 4.9, w: 3, h: 0.3,
  fontSize: 12, color: COLORS.lightGray,
  fontFace: 'Arial', align: 'center'
});

// ============ SLIDE 7: CUSTOMER IMPACT ============
let slide7 = pptx.addSlide();
slide7.background = { color: COLORS.darkBg };

slide7.addText('Addressing Customer Concerns', {
  x: 0.5, y: 0.3, w: 12.33, h: 0.8,
  fontSize: 36, bold: true, color: COLORS.white,
  fontFace: 'Arial', align: 'center'
});

slide7.addText('Not Just Infrastructure — Trust', {
  x: 0.5, y: 1.0, w: 12.33, h: 0.5,
  fontSize: 18, color: COLORS.yellow,
  fontFace: 'Arial', align: 'center'
});

// Before box
slide7.addShape(pptx.ShapeType.roundRect, {
  x: 0.5, y: 1.7, w: 5.9, h: 3.5,
  fill: { color: '3d1a1a' },
  line: { color: COLORS.red, width: 2 }
});
slide7.addText('❌ Current Pain Points', {
  x: 0.7, y: 1.9, w: 5.5, h: 0.5,
  fontSize: 18, bold: true, color: COLORS.red,
  fontFace: 'Arial'
});
slide7.addText([
  { text: '"App doesn\'t work at station"\n', options: { breakLine: true } },
  { text: '"Prices change unexpectedly"\n', options: { breakLine: true } },
  { text: '"Don\'t know if charger works"\n', options: { breakLine: true } },
  { text: '"Route planning is difficult"', options: {} }
], {
  x: 0.9, y: 2.5, w: 5.3, h: 2.5,
  fontSize: 14, color: COLORS.lightGray,
  fontFace: 'Arial'
});

// After box
slide7.addShape(pptx.ShapeType.roundRect, {
  x: 6.9, y: 1.7, w: 5.9, h: 3.5,
  fill: { color: '1a3d1a' },
  line: { color: COLORS.accent, width: 2 }
});
slide7.addText('✓ Our Solution', {
  x: 7.1, y: 1.9, w: 5.5, h: 0.5,
  fontSize: 18, bold: true, color: COLORS.accent,
  fontFace: 'Arial'
});
slide7.addText([
  { text: 'Strategic placement = reliable coverage\n', options: { breakLine: true } },
  { text: 'Demand-based locations = proven usage\n', options: { breakLine: true } },
  { text: 'Grid optimization = consistent availability\n', options: { breakLine: true } },
  { text: 'Customer-first = trust built', options: {} }
], {
  x: 7.1, y: 2.5, w: 5.5, h: 2.5,
  fontSize: 14, color: COLORS.white,
  fontFace: 'Arial'
});

// Quote
slide7.addText('"We analyzed what EV drivers actually complain about — and built our model to solve those exact problems."', {
  x: 0.5, y: 5.5, w: 12.33, h: 0.8,
  fontSize: 14, italic: true, color: COLORS.accent,
  fontFace: 'Arial', align: 'center'
});

// ============ SLIDE 8: NEXT STEPS ============
let slide8 = pptx.addSlide();
slide8.background = { color: '004D2A' };

slide8.addText('The Path Forward', {
  x: 0.5, y: 0.3, w: 12.33, h: 0.8,
  fontSize: 38, bold: true, color: COLORS.white,
  fontFace: 'Arial', align: 'center'
});

slide8.addText('Together, We Can Meet EU Targets — Smarter, Not Just Bigger', {
  x: 0.5, y: 1.0, w: 12.33, h: 0.5,
  fontSize: 16, color: 'CCFFDD',
  fontFace: 'Arial', align: 'center'
});

// Timeline
const timeline = [
  { date: 'Q3 2026', event: 'Pilot Launch', sub: 'Top 50 locations' },
  { date: '2027', event: 'Expand to 200', sub: 'First full year' },
  { date: '2028-2030', event: 'Complete 568', sub: 'Full deployment' }
];

timeline.forEach((t, i) => {
  const x = 1.5 + i * 4;
  
  // Circle
  slide8.addShape(pptx.ShapeType.ellipse, {
    x: x + 1.2, y: 2.0, w: 1, h: 1,
    fill: { color: COLORS.accent }
  });
  
  // Date
  slide8.addText(t.date, {
    x: x, y: 3.2, w: 3.5, h: 0.5,
    fontSize: 20, bold: true, color: COLORS.white,
    fontFace: 'Arial', align: 'center'
  });
  
  // Event
  slide8.addText(t.event, {
    x: x, y: 3.7, w: 3.5, h: 0.4,
    fontSize: 14, color: COLORS.white,
    fontFace: 'Arial', align: 'center'
  });
  
  // Sub
  slide8.addText(t.sub, {
    x: x, y: 4.1, w: 3.5, h: 0.3,
    fontSize: 11, color: 'AADDAA',
    fontFace: 'Arial', align: 'center'
  });
});

// The Ask
slide8.addShape(pptx.ShapeType.roundRect, {
  x: 2.5, y: 5.0, w: 8.33, h: 1.2,
  fill: { color: '007A3D' }
});
slide8.addText('The Ask: Support for pilot implementation and data partnership', {
  x: 2.5, y: 5.3, w: 8.33, h: 0.6,
  fontSize: 18, bold: true, color: COLORS.white,
  fontFace: 'Arial', align: 'center'
});

slide8.addText('Thank you • Questions?', {
  x: 0.5, y: 6.5, w: 12.33, h: 0.4,
  fontSize: 16, color: 'AADDAA',
  fontFace: 'Arial', align: 'center'
});

// Save
pptx.writeFile({ fileName: 'IBERDROLA_DATATHON_2026.pptx' })
  .then(() => console.log('Presentation created: IBERDROLA_DATATHON_2026.pptx'))
  .catch(err => console.error('Error:', err));
