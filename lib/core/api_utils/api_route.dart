class apiRoute {
  //local endpoint
  static const local = "http://localhost:8000";


  static const base = "$local/customer";

  //customer
  static const signUp = "$base/register";
  static const login = "$base/login-user";

  static const addChat = "$base/create-cha";
  static const fetchChat = "$base/fetch-user-chat";


}
