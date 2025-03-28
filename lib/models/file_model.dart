class FileModel {
  final int id;
  final String name;
  final List<String> photos;

  FileModel({required this.id, required this.name, required this.photos});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'photos': photos.join(','),
    };
  }

  factory FileModel.fromMap(Map<String, dynamic> map) {
    return FileModel(
      id: map['id'],
      name: map['name'],
      photos: List<String>.from(map['photos'].split(',')),
    };
  }
}