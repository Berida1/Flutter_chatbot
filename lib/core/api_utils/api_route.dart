class apiRoute {
  //local endpoint
  static const local = "http://10.0.2.2:8000";
  // static const local = "http://127.0.0.1:8000";


  // static const base = "/api";

  //customer
  static const signUp = "$local/api/register";
  static const login = "$local/api/login";
  static const userProfile = "$local/api/fetch-user-profile";

  static const addChat = "$local/api/create-chat";
  static const fetchChat = "$local/api/fetch-user-chat";
}
