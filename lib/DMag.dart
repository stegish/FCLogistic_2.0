//classe che permette il passaggio di informazioni utili tra le varie pagine
class DMag {
  int nPezzi = 0;
  String Nbancale = "";
  String data = "";
  int codice = 0;
  int riga = 0;

  DMag(int codicee, String bancalee, int pezzii, String dataa, int rigaa) {
    nPezzi = pezzii;
    Nbancale = bancalee;
    riga = rigaa;
    codice = codicee;
    data = dataa;
  }

  int getnPezzi() {
    return nPezzi;
  }

  int getColonna() {
    return riga;
  }

  String getBancale() {
    return Nbancale;
  }

  int getCodice() {
    return codice;
  }

  String getData() {
    return data;
  }
}
