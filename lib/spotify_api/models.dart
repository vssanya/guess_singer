class Category {
	final String id;
	final String? name;
	final String? imageUrl;

	Category(this.id): name=null, imageUrl=null;

	Category.fromJson(Map<String, dynamic> json):
		id = json['id'],
		name = json['name'],
		imageUrl = _getImageUrlFromJson(json);

	static String? _getImageUrlFromJson(json) {
		if (json['icons'] == null) {
			return null;
		}

		return json['icons'][0]['url'];
	}

	@override
	String toString() {
		return 'Category(id: $id, name: $name, image: $imageUrl)';
	}
}

class Playlist {
	final String id;
	final String imageUrl;

	final String name;
	final String description;

	Playlist.fromJson(Map<String, dynamic> json):
		id = json['id'],
		imageUrl = json['images'][0]['url'],
		name = json['name'],
		description = json['description'];
}

class Artist {
	final String id;
	final String name;

	final String? imageUrl;

	Artist.fromJson(Map<String, dynamic> json):
		id = json['id'],
		name = json['name'],
		imageUrl = _getImageUrlFromJson(json);
	
	Artist.empty():
		id = "",
		name = "",
		imageUrl = null;

	static String? _getImageUrlFromJson(json) {
		if (json['images'] == null) {
			return null;
		}

		return json['images'][0]['url'];
	}
}

class Track {
	final String id;
	final String name;

	final String? previewUrl;
	final String? imageUrl;

	final List<Artist> artists;

	final int popularity;

	Track.fromJson(Map<String, dynamic> json):
		id = json['id'],
		name = json['name'],
		previewUrl = json['preview_url'],
		imageUrl = _getImageUrlFromJson(json),
		artists = (json['artists'] as List<dynamic>).map((json) => Artist.fromJson(json)).toList(),
		popularity = json['popularity'];

	static String? _getImageUrlFromJson(json) {
		if (json['album']['images'] == null) {
			return null;
		}

		return json['album']['images'][0]['url'];
	}
}
