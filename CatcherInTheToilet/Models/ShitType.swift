enum ShitType: String {
    case normal = "unchi_character"
    case hard   = "unchi_character_yawarakai"
}

extension ShitType {

    var filename: String {
        return rawValue
    }

}
