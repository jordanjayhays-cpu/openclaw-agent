const PptxGenJS = require('pptxgenjs');
const pptx = new PptxGenJS();

pptx.author = 'Team Electric Dragon';
pptx.title = 'Iberdrola Sustainability Datathon Strategy';
pptx.subject = 'EV Charging Network Strategy';

// Color scheme
const COLORS = {
  green: '00974C',
  darkBg: '0D0D1A',
  accent: '00D864',
  yellow: 'FFD700',
  red: 'FF3B30',
  white: 'FFFFFF',
  lightGray: 'AAAAAA',
  darkGray: '2A2A3A'
};

pptx.defineLayout({ name: 'LAYOUT_16x9', width: 13.33, height: 7.5 });
pptx.layout = 'LAYOUT_16x9';

// ============ SLIDE 1: TITLE ============
let slide1 = pptx.addSlide();
slide1.background = { color: COLORS.green };

slide1.addText('SUSTAINABILITY DATATHON', {
  x: 0.5, y: 1.5, w: 12.33, h: 0.5,
  fontSize: 16, bold: true, color: 'CCFFDD',
  fontFace: 'Arial', align: 'center', charSpacing: 8
});

slide1.addText('Iberdrola Strategy', {
  x: 0.5, y: 2.2, w: 12.33, h: 1.2,
  fontSize: 54, bold: true, color: COLORS.white,
  fontFace: 'Arial', align: 'center'
});

slide1.addText('Electric Dragon', {
  x: 0.5, y: 3.5, w: 12.33, h: 0.6,
  fontSize: 28, color: '004D2A',
  fontFace: 'Arial', align: 'center'
});

slide1.addText('Jules Doctora  •  Manuel Mapa  •  Jordan Hays  •  Yi Long  •  Silvia Mendoza  •  Almutasem Falatah', {
  x: 0.5, y: 5.0, w: 12.33, h: 0.4,
  fontSize: 12, color: 'CCFFDD',
  fontFace: 'Arial', align: 'center'
});

// ============ SLIDE 2: THE CONTEXT ============
let slide2 = pptx.addSlide();
slide2.background = { color: COLORS.darkBg };

slide2.addShape(pptx.ShapeType.rect, {
  x: 0, y: 0, w: 0.15, h: 7.5,
  fill: { color: COLORS.green }
});

slide2.addText('THE CONTEXT', {
  x: 0.5, y: 0.4, w: 12, h: 0.6,
  fontSize: 14, bold: true, color: COLORS.green,
  fontFace: 'Arial', charSpacing: 4
});

slide2.addText('Spain\'s Energy Transition: A Pivotal Moment', {
  x: 0.5, y: 0.9, w: 12, h: 0.8,
  fontSize: 32, bold: true, color: COLORS.white,
  fontFace: 'Arial'
});

// EU Regulation Box
slide2.addShape(pptx.ShapeType.roundRect, {
  x: 0.5, y: 1.9, w: 5.8, h: 2.4,
  fill: { color: COLORS.darkGray }
});
slide2.addText('EU AFIR Regulation', {
  x: 0.7, y: 2.0, w: 5.4, h: 0.5,
  fontSize: 16, bold: true, color: COLORS.green,
  fontFace: 'Arial'
});
slide2.addText([
  { text: '• 150 kW fast-charging every 60 km\n', options: { breakLine: true } },
  { text: '• TEN-T core network coverage\n', options: { breakLine: true } },
  { text: '• Mandatory from 2025\n', options: { breakLine: true } },
  { text: '• Full coverage by 2030', options: {} }
], {
  x: 0.7, y: 2.5, w: 5.4, h: 1.6,
  fontSize: 13, color: COLORS.lightGray,
  fontFace: 'Arial'
});

// Spain Target Box
slide2.addShape(pptx.ShapeType.roundRect, {
  x: 6.8, y: 1.9, w: 5.8, h: 2.4,
  fill: { color: COLORS.darkGray }
});
slide2.addText('Spain PNIEC Target', {
  x: 7.0, y: 2.0, w: 5.4, h: 0.5,
  fontSize: 16, bold: true, color: COLORS.yellow,
  fontFace: 'Arial'
});
slide2.addText([
  { text: '• 5.5 million EVs by 2030\n', options: { breakLine: true } },
  { text: '• Currently ~550,000 EVs\n', options: { breakLine: true } },
  { text: '• Long-distance bottleneck\n', options: { breakLine: true } },
  { text: '• Range anxiety persists', options: {} }
], {
  x: 7.0, y: 2.5, w: 5.4, h: 1.6,
  fontSize: 13, color: COLORS.lightGray,
  fontFace: 'Arial'
});

// The Problem
slide2.addShape(pptx.ShapeType.roundRect, {
  x: 0.5, y: 4.6, w: 12.33, h: 1.6,
  fill: { color: '1a1a2a' },
  line: { color: COLORS.red, width: 2 }
});
slide2.addText('THE PROBLEM', {
  x: 0.7, y: 4.75, w: 3, h: 0.4,
  fontSize: 12, bold: true, color: COLORS.red,
  fontFace: 'Arial'
});
slide2.addText('"Range anxiety" blocks EV adoption. Drivers fear being stranded on inter-urban corridors.', {
  x: 0.7, y: 5.2, w: 11.9, h: 0.8,
  fontSize: 18, color: COLORS.white,
  fontFace: 'Arial'
});

// ============ SLIDE 3: VALUE PROPOSITION ============
let slide3 = pptx.addSlide();
slide3.background = { color: COLORS.darkBg };

slide3.addShape(pptx.ShapeType.rect, {
  x: 0, y: 0, w: 0.15, h: 7.5,
  fill: { color: COLORS.green }
});

slide3.addText('VALUE PROPOSITION', {
  x: 0.5, y: 0.4, w: 12, h: 0.6,
  fontSize: 14, bold: true, color: COLORS.green,
  fontFace: 'Arial', charSpacing: 4
});

slide3.addText('Reliable, Fast, Green Charging', {
  x: 0.5, y: 1.2, w: 12, h: 0.8,
  fontSize: 36, bold: true, color: COLORS.white,
  fontFace: 'Arial', align: 'center'
});

slide3.addText('on every inter-urban corridor', {
  x: 0.5, y: 2.0, w: 12, h: 0.6,
  fontSize: 24, color: COLORS.accent,
  fontFace: 'Arial', align: 'center'
});

// Three pillars
const pillars = [
  { icon: '⚡', title: 'RELIABLE', desc: 'Charging stations that work\nwhen drivers need them' },
  { icon: '🚀', title: 'FAST', desc: '150 kW minimum power\nminimum wait time' },
  { icon: '🌿', title: 'GREEN', desc: '100% renewable energy\nsustainable infrastructure' }
];

pillars.forEach((p, i) => {
  const x = 0.8 + i * 4.2;
  slide3.addShape(pptx.ShapeType.roundRect, {
    x: x, y: 3.0, w: 3.8, h: 3.2,
    fill: { color: COLORS.darkGray }
  });
  slide3.addText(p.icon, {
    x: x, y: 3.3, w: 3.8, h: 0.8,
    fontSize: 40, align: 'center'
  });
  slide3.addText(p.title, {
    x: x, y: 4.1, w: 3.8, h: 0.5,
    fontSize: 18, bold: true, color: COLORS.green,
    fontFace: 'Arial', align: 'center'
  });
  slide3.addText(p.desc, {
    x: x + 0.2, y: 4.7, w: 3.4, h: 1.2,
    fontSize: 12, color: COLORS.lightGray,
    fontFace: 'Arial', align: 'center'
  });
});

// ============ SLIDE 4: THREE OBJECTIVES ============
let slide4 = pptx.addSlide();
slide4.background = { color: COLORS.darkBg };

slide4.addShape(pptx.ShapeType.rect, {
  x: 0, y: 0, w: 0.15, h: 7.5,
  fill: { color: COLORS.green }
});

slide4.addText('STRATEGIC FRAMEWORK', {
  x: 0.5, y: 0.4, w: 12, h: 0.6,
  fontSize: 14, bold: true, color: COLORS.green,
  fontFace: 'Arial', charSpacing: 4
});

slide4.addText('Three Core Objectives', {
  x: 0.5, y: 0.9, w: 12, h: 0.7,
  fontSize: 32, bold: true, color: COLORS.white,
  fontFace: 'Arial'
});

// Objective 1
slide4.addShape(pptx.ShapeType.roundRect, {
  x: 0.5, y: 1.8, w: 4, h: 5,
  fill: { color: COLORS.darkGray }
});
slide4.addText('01', {
  x: 0.7, y: 1.95, w: 1, h: 0.6,
  fontSize: 24, bold: true, color: COLORS.green,
  fontFace: 'Arial'
});
slide4.addText('CHARGING NETWORK\nOPTIMIZATION', {
  x: 0.7, y: 2.5, w: 3.6, h: 0.8,
  fontSize: 14, bold: true, color: COLORS.white,
  fontFace: 'Arial'
});
slide4.addText([
  { text: '• Maximize Utilization Rates\n', options: { breakLine: true } },
  { text: '• Maximize Convenience\n', options: { breakLine: true } },
  { text: '  (Distance between Stations)\n', options: { breakLine: true } },
  { text: '• Minimize Capex\n', options: { breakLine: true } },
  { text: '• Maximize Profitability', options: {} }
], {
  x: 0.7, y: 3.4, w: 3.6, h: 2.5,
  fontSize: 12, color: COLORS.lightGray,
  fontFace: 'Arial'
});

// Objective 2
slide4.addShape(pptx.ShapeType.roundRect, {
  x: 4.7, y: 1.8, w: 4, h: 5,
  fill: { color: COLORS.darkGray }
});
slide4.addText('02', {
  x: 4.9, y: 1.95, w: 1, h: 0.6,
  fontSize: 24, bold: true, color: COLORS.yellow,
  fontFace: 'Arial'
});
slide4.addText('GRID VIABILITY\nANALYSIS', {
  x: 4.9, y: 2.5, w: 3.6, h: 0.8,
  fontSize: 14, bold: true, color: COLORS.white,
  fontFace: 'Arial'
});
slide4.addText([
  { text: '• Grid Constraint Mapping\n', options: { breakLine: true } },
  { text: '• Friction Points\n', options: { breakLine: true } },
  { text: '  Identification\n', options: { breakLine: true } },
  { text: '• Capacity Assessment\n', options: { breakLine: true } },
  { text: '• Infrastructure Readiness', options: {} }
], {
  x: 4.9, y: 3.4, w: 3.6, h: 2.5,
  fontSize: 12, color: COLORS.lightGray,
  fontFace: 'Arial'
});

// Objective 3
slide4.addShape(pptx.ShapeType.roundRect, {
  x: 8.9, y: 1.8, w: 4, h: 5,
  fill: { color: COLORS.darkGray }
});
slide4.addText('03', {
  x: 9.1, y: 1.95, w: 1, h: 0.6,
  fontSize: 24, bold: true, color: COLORS.accent,
  fontFace: 'Arial'
});
slide4.addText('STRATEGY &\nVALUE PROPOSITION', {
  x: 9.1, y: 2.5, w: 3.6, h: 0.8,
  fontSize: 14, bold: true, color: COLORS.white,
  fontFace: 'Arial'
});
slide4.addText([
  { text: '• Improve Optimization Model\n', options: { breakLine: true } },
  { text: '• Address Friction Points\n', options: { breakLine: true } },
  { text: '• Implementation Timeline\n', options: { breakLine: true } },
  { text: '• Partnership Strategy', options: {} }
], {
  x: 9.1, y: 3.4, w: 3.6, h: 2.5,
  fontSize: 12, color: COLORS.lightGray,
  fontFace: 'Arial'
});

// ============ SLIDE 5: EV PROJECTION ============
let slide5 = pptx.addSlide();
slide5.background = { color: COLORS.darkBg };

slide5.addShape(pptx.ShapeType.rect, {
  x: 0, y: 0, w: 0.15, h: 7.5,
  fill: { color: COLORS.green }
});

slide5.addText('MARKET ANALYSIS', {
  x: 0.5, y: 0.4, w: 12, h: 0.6,
  fontSize: 14, bold: true, color: COLORS.green,
  fontFace: 'Arial', charSpacing: 4
});

slide5.addText('2027 EV Fleet Projection', {
  x: 0.5, y: 0.9, w: 12, h: 0.7,
  fontSize: 32, bold: true, color: COLORS.white,
  fontFace: 'Arial'
});

// Big numbers
slide5.addShape(pptx.ShapeType.roundRect, {
  x: 0.5, y: 1.8, w: 4, h: 2.5,
  fill: { color: '1a3d1a' },
  line: { color: COLORS.green, width: 2 }
});
slide5.addText('1.7M', {
  x: 0.5, y: 2.0, w: 4, h: 1.2,
  fontSize: 60, bold: true, color: COLORS.accent,
  fontFace: 'Arial', align: 'center'
});
slide5.addText('Projected EVs in 2027\n(Conservative Scenario)', {
  x: 0.5, y: 3.2, w: 4, h: 0.8,
  fontSize: 12, color: COLORS.lightGray,
  fontFace: 'Arial', align: 'center'
});

slide5.addShape(pptx.ShapeType.roundRect, {
  x: 4.7, y: 1.8, w: 4, h: 2.5,
  fill: { color: '1a3d1a' },
  line: { color: COLORS.green, width: 2 }
});
slide5.addText('88K', {
  x: 4.7, y: 2.0, w: 4, h: 1.2,
  fontSize: 60, bold: true, color: COLORS.accent,
  fontFace: 'Arial', align: 'center'
});
slide5.addText('Daily Average Sessions\nProjected', {
  x: 4.7, y: 3.2, w: 4, h: 0.8,
  fontSize: 12, color: COLORS.lightGray,
  fontFace: 'Arial', align: 'center'
});

slide5.addShape(pptx.ShapeType.roundRect, {
  x: 8.9, y: 1.8, w: 4, h: 2.5,
  fill: { color: '3d3d1a' },
  line: { color: COLORS.yellow, width: 2 }
});
slide5.addText('36.6%', {
  x: 8.9, y: 2.0, w: 4, h: 1.2,
  fontSize: 60, bold: true, color: COLORS.yellow,
  fontFace: 'Arial', align: 'center'
});
slide5.addText('Initial CAGR\n(Declining 15%/yr)', {
  x: 8.9, y: 3.2, w: 4, h: 0.8,
  fontSize: 12, color: COLORS.lightGray,
  fontFace: 'Arial', align: 'center'
});

// Key Variables
slide5.addText('Capacity Design Variables', {
  x: 0.5, y: 4.5, w: 12, h: 0.5,
  fontSize: 18, bold: true, color: COLORS.white,
  fontFace: 'Arial'
});

const variables = [
  { title: 'Day of Week', desc: '>1.0 = Leisure routes\n<1.0 = Commuter routes' },
  { title: 'Month', desc: 'Higher in Mar, Jun,\nOct-Dec (fleet cycles)' },
  { title: 'Hour of Day', desc: 'Peak demand\npatterns by time' },
  { title: 'Road Route', desc: 'Uniform growth\ng nationally' }
];

variables.forEach((v, i) => {
  const x = 0.5 + i * 3.2;
  slide5.addShape(pptx.ShapeType.roundRect, {
    x: x, y: 5.1, w: 3, h: 1.8,
    fill: { color: COLORS.darkGray }
  });
  slide5.addText(v.title, {
    x: x + 0.15, y: 5.2, w: 2.7, h: 0.4,
    fontSize: 12, bold: true, color: COLORS.green,
    fontFace: 'Arial'
  });
  slide5.addText(v.desc, {
    x: x + 0.15, y: 5.6, w: 2.7, h: 1.1,
    fontSize: 10, color: COLORS.lightGray,
    fontFace: 'Arial'
  });
});

// ============ SLIDE 6: PROPOSED STATIONS ============
let slide6 = pptx.addSlide();
slide6.background = { color: COLORS.darkBg };

slide6.addShape(pptx.ShapeType.rect, {
  x: 0, y: 0, w: 0.15, h: 7.5,
  fill: { color: COLORS.green }
});

slide6.addText('PROPOSED SOLUTION', {
  x: 0.5, y: 0.4, w: 12, h: 0.6,
  fontSize: 14, bold: true, color: COLORS.green,
  fontFace: 'Arial', charSpacing: 4
});

slide6.addText('Charging Station Requirements', {
  x: 0.5, y: 0.9, w: 12, h: 0.7,
  fontSize: 32, bold: true, color: COLORS.white,
  fontFace: 'Arial'
});

// Minimum
slide6.addShape(pptx.ShapeType.roundRect, {
  x: 0.5, y: 1.8, w: 4, h: 1.8,
  fill: { color: COLORS.darkGray }
});
slide6.addText('MINIMUM', {
  x: 0.7, y: 1.95, w: 3.6, h: 0.4,
  fontSize: 12, bold: true, color: COLORS.lightGray,
  fontFace: 'Arial'
});
slide6.addText('2 Chargers', {
  x: 0.7, y: 2.4, w: 3.6, h: 0.8,
  fontSize: 36, bold: true, color: COLORS.white,
  fontFace: 'Arial'
});
slide6.addText('per station minimum', {
  x: 0.7, y: 3.1, w: 3.6, h: 0.3,
  fontSize: 11, color: COLORS.lightGray,
  fontFace: 'Arial'
});

// Business Model
slide6.addShape(pptx.ShapeType.roundRect, {
  x: 4.7, y: 1.8, w: 8.1, h: 1.8,
  fill: { color: '1a3d1a' },
  line: { color: COLORS.green, width: 2 }
});
slide6.addText('VIABILITY (Business Model)', {
  x: 4.9, y: 1.95, w: 7.7, h: 0.4,
  fontSize: 12, bold: true, color: COLORS.green,
  fontFace: 'Arial'
});
slide6.addText([
  { text: 'Revenue: Pay-per-kWh (€0.45-0.65/kWh)  •  Fleet subscriptions  •  OCPI roaming  •  EU AFIR/CEF grants (up to 30% CAPEX)  •  Grid ancillary services (FCR/mFRR)  •  Media & co-branding', options: {} }
], {
  x: 4.9, y: 2.4, w: 7.7, h: 1,
  fontSize: 11, color: COLORS.lightGray,
  fontFace: 'Arial'
});

// CAPEX Breakdown
slide6.addText('CAPEX Breakdown', {
  x: 0.5, y: 3.9, w: 12, h: 0.5,
  fontSize: 18, bold: true, color: COLORS.white,
  fontFace: 'Arial'
});

slide6.addShape(pptx.ShapeType.roundRect, {
  x: 0.5, y: 4.5, w: 5.8, h: 2.5,
  fill: { color: COLORS.darkGray }
});
slide6.addText('€2.08M', {
  x: 0.5, y: 4.7, w: 5.8, h: 1,
  fontSize: 48, bold: true, color: COLORS.yellow,
  fontFace: 'Arial', align: 'center'
});
slide6.addText('Average Total per Site', {
  x: 0.5, y: 5.6, w: 5.8, h: 0.4,
  fontSize: 14, color: COLORS.lightGray,
  fontFace: 'Arial', align: 'center'
});

slide6.addText([
  { text: '• Charger hardware: €25-40k/unit\n', options: { breakLine: true } },
  { text: '• Grid connection: €80-300k/site', options: {} }
], {
  x: 6.5, y: 4.8, w: 6, h: 1.5,
  fontSize: 14, color: COLORS.lightGray,
  fontFace: 'Arial'
});

// ============ SLIDE 7: METHODOLOGY ============
let slide7 = pptx.addSlide();
slide7.background = { color: COLORS.darkBg };

slide7.addShape(pptx.ShapeType.rect, {
  x: 0, y: 0, w: 0.15, h: 7.5,
  fill: { color: COLORS.green }
});

slide7.addText('METHODOLOGY', {
  x: 0.5, y: 0.4, w: 12, h: 0.6,
  fontSize: 14, bold: true, color: COLORS.green,
  fontFace: 'Arial', charSpacing: 4
});

slide7.addText('Analytics Approach', {
  x: 0.5, y: 0.9, w: 12, h: 0.7,
  fontSize: 32, bold: true, color: COLORS.white,
  fontFace: 'Arial'
});

// Steps
const steps = [
  { num: '1', title: 'Forecast Registrations', desc: 'Identify distribution of cars per lane' },
  { num: '2', title: 'Day-of-Week Analysis', desc: 'Forecast daily sessions per lane (sedan/family car, 80% volume assumption)' },
  { num: '3', title: 'Customer Profiling', desc: 'Segment analysis by route type and usage patterns' },
  { num: '4', title: 'P80 Utilization', desc: 'Size infrastructure for peak demand scenarios' }
];

steps.forEach((s, i) => {
  const y = 1.8 + i * 1.35;
  
  slide7.addShape(pptx.ShapeType.ellipse, {
    x: 0.6, y: y, w: 0.7, h: 0.7,
    fill: { color: COLORS.green }
  });
  slide7.addText(s.num, {
    x: 0.6, y: y + 0.1, w: 0.7, h: 0.5,
    fontSize: 20, bold: true, color: COLORS.white,
    fontFace: 'Arial', align: 'center'
  });
  
  slide7.addText(s.title, {
    x: 1.5, y: y, w: 4, h: 0.5,
    fontSize: 16, bold: true, color: COLORS.white,
    fontFace: 'Arial'
  });
  slide7.addText(s.desc, {
    x: 1.5, y: y + 0.45, w: 10, h: 0.5,
    fontSize: 12, color: COLORS.lightGray,
    fontFace: 'Arial'
  });
});

// ============ SLIDE 8: TIMELINE ============
let slide8 = pptx.addSlide();
slide8.background = { color: COLORS.darkBg };

slide8.addShape(pptx.ShapeType.rect, {
  x: 0, y: 0, w: 0.15, h: 7.5,
  fill: { color: COLORS.green }
});

slide8.addText('IMPLEMENTATION', {
  x: 0.5, y: 0.4, w: 12, h: 0.6,
  fontSize: 14, bold: true, color: COLORS.green,
  fontFace: 'Arial', charSpacing: 4
});

slide8.addText('Strategic Timeline', {
  x: 0.5, y: 0.9, w: 12, h: 0.7,
  fontSize: 32, bold: true, color: COLORS.white,
  fontFace: 'Arial'
});

// Timeline line
slide8.addShape(pptx.ShapeType.rect, {
  x: 1, y: 3.5, w: 11, h: 0.05,
  fill: { color: COLORS.green }
});

const timeline = [
  { year: '2025', milestone: 'AFIR\nDeadline', sub: '60km coverage\nTEN-T core' },
  { year: '2026', milestone: 'Grid\nAssessment', sub: 'Friction point\nmapping' },
  { year: '2027', milestone: 'Pilot\nLaunch', sub: 'Top locations\nfirst' },
  { year: '2030', milestone: 'Full\nCoverage', sub: '5.5M EVs\nsupported' }
];

timeline.forEach((t, i) => {
  const x = 1.5 + i * 3;
  
  slide8.addShape(pptx.ShapeType.ellipse, {
    x: x + 0.7, y: 3.25, w: 0.5, h: 0.5,
    fill: { color: COLORS.green }
  });
  
  slide8.addText(t.year, {
    x: x, y: 2.3, w: 2, h: 0.5,
    fontSize: 24, bold: true, color: COLORS.yellow,
    fontFace: 'Arial', align: 'center'
  });
  
  slide8.addText(t.milestone, {
    x: x, y: 2.8, w: 2, h: 0.7,
    fontSize: 14, bold: true, color: COLORS.white,
    fontFace: 'Arial', align: 'center'
  });
  
  slide8.addText(t.sub, {
    x: x, y: 4.0, w: 2, h: 0.8,
    fontSize: 10, color: COLORS.lightGray,
    fontFace: 'Arial', align: 'center'
  });
});

// Save
pptx.writeFile({ fileName: 'IBERDROLA_STRATEGY.pptx' })
  .then(() => console.log('Done: IBERDROLA_STRATEGY.pptx'))
  .catch(err => console.error(err));
