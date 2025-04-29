


// 📍 قائمة الولايات الجزائرية مع الأرقام

const List<String> wilayas = [
  "01 - Adrar",
  "02 - Chlef",
  "03 - Laghouat",
  "04 - Oum El Bouaghi",
  "05 - Batna",
  "06 - Béjaïa",
  "07 - Biskra",
  "08 - Béchar",
  "09 - Blida",
  "10 - Bouira",
  "11 - Tamanrasset",
  "12 - Tébessa",
  "13 - Tlemcen",
  "14 - Tiaret",
  "15 - Tizi Ouzou",
  "16 - Algiers",
  "17 - Djelfa",
  "18 - Jijel",
  "19 - Sétif",
  "20 - Saïda",
  "21 - Skikda",
  "22 - Sidi Bel Abbès",
  "23 - Annaba",
  "24 - Guelma",
  "25 - Constantine",
  "26 - Médéa",
  "27 - Mostaganem",
  "28 - M'Sila",
  "29 - Mascara",
  "30 - Ouargla",
  "31 - Oran",
  "32 - El Bayadh",
  "33 - Illizi",
  "34 - Bordj Bou Arréridj",
  "35 - Boumerdès",
  "36 - El Tarf",
  "37 - Tindouf",
  "38 - Tissemsilt",
  "39 - El Oued",
  "40 - Khenchela",
  "41 - Souk Ahras",
  "42 - Tipaza",
  "43 - Mila",
  "44 - Aïn Defla",
  "45 - Naâma",
  "46 - Aïn Témouchent",
  "47 - Ghardaïa",
  "48 - Relizane",
  "49 - El M'Ghair",
  "50 - El Menia",
  "51 - Ouled Djellal",
  "52 - Bordj Baji Mokhtar",
  "53 - Beni Abbes",
  "54 - Timimoun",
  "55 - Touggourt",
  "56 - Djanet",
  "57 - Ain Salah",
  "58 - Ain Guezzam"
];



// 🎓 المستويات الدراسية
const List<String> educationLevels = [
  "None",
  "Primary",
  "Middle School",
  "High School",
  "Vocational Training",
  "Technician",
  "Bachelor's Degree",
  "Master's Degree",
  "Doctorate"
];



// 💡 الاهتمامات (مجالات موسعة)
const List<String> interests = [
  "Technology & IT",
  "Design & Creativity",
  "Business & Entrepreneurship",
  "Marketing & Advertising",
  "Healthcare & Nursing",
  "Education & Teaching",
  "Engineering",
  "Construction",
  "Electricity & Electronics",
  "Mechanical Work",
  "Agriculture",
  "Handicrafts",
  "Art & Photography",
  "Beauty & Aesthetics",
  "Cooking & Catering",
  "Languages & Translation",
  "Accounting & Finance",
  "Law & Legal Studies",
  "Logistics & Transportation",
  "Sports & Fitness",
  "Social Work",
  "Other"
];



// 🛠️ المهارات (شاملة المجالات التقنية والناعمة)
const List<String> skills = [
  "Communication",
  "Problem Solving",
  "Critical Thinking",
  "Teamwork",
  "Creativity",
  "Time Management",
  "Adaptability",
  "Leadership",
  "Customer Service",
  "Sales",
  "Microsoft Office",
  "Data Entry",
  "Flutter",
  "Java",
  "Python",
  "HTML/CSS/JS",
  "UI/UX Design",
  "Graphic Design",
  "Electrical Installation",
  "Plumbing",
  "Carpentry",
  "Welding",
  "Tailoring",
  "Auto Repair",
  "Cooking",
  "Makeup/Hairdressing",
  "Video Editing",
  "Social Media Management",
  "Project Management",
  "Other"
];

// 1. COMPANY/EMPLOYER FIELDS مجالات عمل الشركة 😎🔽🔽
const List<String> industryList = [
  'Technology',
  'Healthcare',
  'Finance',
  'Education',
  'Manufacturing',
  'Retail',
  'Construction',
  'Hospitality',
  'Transportation',
  'Energy',
  'Telecommunications',
  'Agriculture',
  'Media & Entertainment',
  'Government',
  'Non-Profit',
  'Other'
];

//حجم الشركة 🔽🔽🔽

const List<String> companySizeList = [
  '1-10 employees',
  '11-50 employees',
  '51-200 employees',
  '201-500 employees',
  '501-1000 employees',
  '1001+ employees'
];

// 2. TRAINING CENTER/INSTITUTION FIELDS   نوع المركز التكويني
const List<String> institutionTypeList = [
  'Government',
  'Private',
  'Non-Profit',
  'University',
  'Vocational',
  'Online Platform'
];

// المجالات التي يقدمون فيها تكوينات

const List<String> specializationsList = [
  'IT & Software',
  'Business Management',
  'Healthcare',
  'Engineering',
  'Design & Creative',
  'Language Training',
  'Vocational Skills',
  'Safety Training',
  'Teacher Training',
  'Leadership Development',
  'Digital Marketing',
  'Data Science',
  'Artificial Intelligence',
  'Renewable Energy',
  'Hospitality Management'
];

// 3. TRAINER/COURSE PROVIDER FIELDS المجالاتي التي يغطيها المدرب | عارض التكوين
const List<String> expertiseAreasList = [
  'Programming',
  'Graphic Design',
  'Digital Marketing',
  'Project Management',
  'Data Analysis',
  'Cybersecurity',
  'Cloud Computing',
  'Artificial Intelligence',
  'Machine Learning',
  'Web Development',
  'Mobile Development',
  'UI/UX Design',
  'Business Strategy',
  'Financial Analysis',
  'Language Instruction',
  'Soft Skills Training',
  'Technical Writing',
  'Quality Assurance',
  'DevOps',
  'Blockchain'
];

// اللقب المهني او الرتية

const List<String> professionalTitlesList = [
  'Dr.',
  'Eng.',
  'Prof.',
  'Mr.',
  'Mrs.',
  'Ms.',
  'Trainer',
  'Coach',
  'Consultant',
  'Specialist'
];

// For multi-select fields, you can use these with CheckboxListTile or MultiSelectDropdown
const Map<String, List<String>> multiSelectOptions = {
  'specializations': specializationsList,
  'expertiseAreas': expertiseAreasList
};


const List<String> experienceLevels = [
  '1-3 years', '3-5 years', '5-10 years', '10+ years'
];

List<Map<String, dynamic>> courses = [
  {
    'courseTitle': 'Web Development Bootcamp',
    'centerName': 'Algerian Tech Center',
    'wilaya': 'Algiers',
    'domain': 'Technology',
    'startDate': '1 May 2025',
    'description': 'An intensive web dev training program...',
    'logoUrl': 'https://example.com/logo.png',
  },
  {
    'courseTitle': 'Graphic Design Fundamentals',
    'centerName': 'Design Academy DZ',
    'wilaya': 'Oran',
    'domain': 'Design',
    'startDate': '10 May 2025',
    'description': 'Learn the basics of graphic design...',
    'logoUrl': 'https://example.com/logo2.png',
  },
];
