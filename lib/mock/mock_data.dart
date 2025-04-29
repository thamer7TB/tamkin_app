
import '../models/User_1/course_opportunity_model.dart';

// بيانات تجريبية للتكوينات
List<CourseOpportunityModel> mockCourses = [
  CourseOpportunityModel(
    id: 'course001',
    courseTitle: 'Web Development Bootcamp',
    centerId: 'center001',
    centerName: 'Algerian Tech Center',
    wilaya: 'Algiers',
    domain: 'Technology',
    startDate: '1 May 2025',
    description: 'Learn HTML, CSS, JavaScript, and frameworks in this full course.',
    logoUrl: 'https://example.com/logo1.png',
    isSaved: false,
  ),
  CourseOpportunityModel(
    id: 'course002',
    courseTitle: 'UI/UX Design Fundamentals',
    centerId: 'center002',
    centerName: 'Design School DZ',
    wilaya: 'Oran',
    domain: 'Design',
    startDate: '10 May 2025',
    description: 'Master user interface and experience design principles.',
    logoUrl: 'https://example.com/logo2.png',
    isSaved: true,
  ),
];

// بيانات تجريبية لمراكز التكوين
Map<String, Map<String, dynamic>> mockCenters = {
  'center001': {
    'centerName': 'Algerian Tech Center',
    'logoUrl': 'https://example.com/logo1.png',
    'description': 'A leading center in digital technologies and web development.',
    'wilaya': 'Algiers',
    'commune': 'Bir Mourad Rais',
    'street': 'Rue El Nasr, Building 14',
    'email': 'contact@algtech.dz',
    'phoneNumber': '+213 770 123 001',
    'website': 'https://algtech.dz',
    'facebook': 'https://facebook.com/algtechcenter',
    'linkedin': 'https://linkedin.com/company/algtechcenter',
    'x': 'https://x.com/algtechcenter',
  },
  'center002': {
    'centerName': 'Design School DZ',
    'logoUrl': 'https://example.com/logo2.png',
    'description': 'Center focused on creative digital design and branding.',
    'wilaya': 'Oran',
    'commune': 'Hai El Yasmine',
    'street': '5 July Avenue, Bloc C',
    'email': 'hello@designschool.dz',
    'phoneNumber': '+213 770 123 002',
    'website': 'https://designschool.dz',
    'facebook': 'https://facebook.com/designschooldz',
    'linkedin': 'https://linkedin.com/company/designschooldz',
    'x': 'https://x.com/designschooldz',
  },
};



