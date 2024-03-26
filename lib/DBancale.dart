//classe che permette il passaggio di informazioni utili tra le varie pagine
class DBancale{
  List<int> nPezziC =[];
  String Nbancale = "";
  String Dbancale ="";
  List<int> codiciC = [];
  List<String> dateC = [];

  DBancale(String bancalee, String dataa, List<int> codicee,List<int> pezzii, List<String> datee){
    nPezziC = pezzii;
    Nbancale = bancalee;
    codiciC = codicee;
    Dbancale = dataa;
    dateC = datee;
  }

  List<int> getnPezziC(){
    return nPezziC;
  }

  String getBancale(){
    return Nbancale;
  }

  List<int> getCodiciC(){
    return codiciC;
  }

  String getData(){
    return Dbancale;
  }

  List<String> getDateC(){
    return dateC;
  }

  int sommaCodici(){
    return codiciC.length;
  }
}