using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Description;
using DAL;

namespace API.Controllers
{
  public class Tbl_FaaliyetController : ApiController
  {
    private hfrEntities db = new hfrEntities();

    // GET: api/tbl_Faaliyet
    [Route("api/faaliyetListele/tbl_Faaliyet")]
    public IQueryable<tbl_Faaliyet> Gettbl_Faaliyet()
    {
      return db.tbl_Faaliyet;
    }

    // GET: api/tbl_Faaliyet/5

    [ResponseType(typeof(tbl_Faaliyet))]
    [Route("api/kullaniciIdFaaliyetListele/tbl_Faaliyet")]
    [HttpGet]
    public IHttpActionResult Gettbl_Faaliyet(int Kullanici_ID)
    {


      //List<tbl_Faaliyet> tbl_Faaliyet = db.tbl_Faaliyet.Where(x => x.Kullanici_ID == Kullanici_ID ).OrderBy(x=>x.Tarih).ToList();

      var list = db.SP_KullaniciFaaliyetListele(Kullanici_ID);

      if (list == null)
      {
        NotFound();
      }

      return Ok(list);
    }

    // GET: api/tbl_Faaliyet/5

    [ResponseType(typeof(tbl_Faaliyet))]
    [Route("api/faaliyetDurumGuncelleme/tbl_Faaliyet")]
    [HttpGet]
    public IHttpActionResult GetDurumGuncellemetbl_Faaliyet(int yil, int ay, int hafta, int id, int deger)
    {



      var list = db.SP_FaaliyetDurumGuncelleme(yil, ay, hafta, id, deger);

      if (list.ToString() == null)
      {
        NotFound();
      }

      return Ok(list);
    }



    [ResponseType(typeof(tbl_Faaliyet))]
    [Route("api/kullaniciDetay/tbl_Faaliyet")]
    [HttpGet]
    public IHttpActionResult KullaniciDetay_tblFaaliyet(int kullanici_ID)
    {


      //List<tbl_Faaliyet> tbl_Faaliyet = db.tbl_Faaliyet.Where(x => x.Kullanici_ID == Kullanici_ID).OrderBy(x => x.Tarih).ToList();

      var list = db.SP_KullaniciDetay(kullanici_ID);

      if (list == null)
      {
        NotFound();
      }
      return Ok(list);

    }

    // POST: api/kullaniciTarihArama : Kullanıcı Faaliyet Tarihi Arama
    [ResponseType(typeof(tbl_Faaliyet))]
    [Route("api/kullaniciFaaliyetlerListeleme/tbl_Faaliyet")]
    [HttpPost]
    public IHttpActionResult KullaniciTarihAramatbl_Faaliyet(string tarih, int hafta, int id)
    {
      char[] ayrac = { '-' };
      string[] parcalar = tarih.Split(ayrac);
      string ay = parcalar[1];
      string yil = parcalar[0];
      string date;

      date = tarih + "- 01";

      DateTime datetime = DateTime.Parse(date);

      var list = db.SP_FaaliyetArama(datetime, hafta, id);
      if (list == null)
      {
        return NotFound();
      }
      return Ok(list);
    }





    [ResponseType(typeof(void))]
    [Route("api/faaliyetGuncelle/tbl_Faaliyet")]
    [HttpPost]
    public IHttpActionResult Possttbl_Faaliyet(int id, int kullaniciID, DateTime tarih, int hafta, string baslik,string faaliyet)
    {

      var lis = db.SP_FaaliyetGuncelle(id,kullaniciID,tarih,hafta,baslik,faaliyet);



      if (!ModelState.IsValid)
      {
        return BadRequest(ModelState);
      }
    else  if (lis==-1)
      {
        return NotFound();
      }
      
      return Ok(lis);

      //if (!ModelState.IsValid)
      //{
      //  return BadRequest(ModelState);
      //}

      //if (id != tbl_Faaliyet.ID)
      //{
      //  return BadRequest();
      //}

      //db.Entry(tbl_Faaliyet).State = EntityState.Modified;

      //try
      //{
      //  db.SaveChanges();
      //}
      //catch (DbUpdateConcurrencyException)
      //{
      //  if (!Tbl_FaaliyetExists(id))
      //  {
      //    return NotFound();
      //  }
      //  else
      //  {
      //    throw;
      //  }
      //}

      //return statuscode(httpstatuscode.nocontent);
    }



    //POST: api/tbl_Faaliyet


    [ResponseType(typeof(tbl_Faaliyet))]
    [Route("api/faaliyetEkle/tbl_Faaliyet")]
    [HttpPost]
    public IHttpActionResult Posttbl_FaaliyetGrup(int id, DateTime tarih, int hafta, string baslik, string faaliyet)
    {


      var lis = db.SP_FaaliyetKontrol(id, tarih, hafta, baslik, faaliyet);



      if (!ModelState.IsValid)
      {
        return BadRequest(ModelState);
      }
      else if (lis==null)
      {
        return NotFound();
      }
     

      return Ok(lis);
    }

    // DELETE: api/tbl_Faaliyet/5
    [ResponseType(typeof(tbl_Faaliyet))]
    [Route("api/faaliyetSil/tbl_Faaliyet")]
    [HttpDelete]
    public IHttpActionResult Deletetbl_Faaliyet(int id)
    {
      tbl_Faaliyet tbl_Faaliyet = db.tbl_Faaliyet.Find(id);
      if (tbl_Faaliyet == null)
      {
        return NotFound();
      }

      db.tbl_Faaliyet.Remove(tbl_Faaliyet);
      db.SaveChanges();

      return Ok(tbl_Faaliyet);
    }

    protected override void Dispose(bool disposing)
    {
      if (disposing)
      {
        db.Dispose();
      }
      base.Dispose(disposing);
    }

    private bool Tbl_FaaliyetExists(int id)
    {
      return db.tbl_Faaliyet.Count(e => e.ID == id) > 0;
    }
  }
}