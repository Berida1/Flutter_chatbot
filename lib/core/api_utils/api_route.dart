class apiRoute {
  //local endpoint
  static const local = "http://localhost:8000";


  // static const base = "/api";

  //customer
  static const signUp = "$local/api/register";
  static const login = "$local/api/login";
  static const userProfile = "$local/api/fetch-user-profile";


  static const addChat = "$local/api/create-chat";
  static const fetchChat = "$local/api/fetch-user-chat";
}
