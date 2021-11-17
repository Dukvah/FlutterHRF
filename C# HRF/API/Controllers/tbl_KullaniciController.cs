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

  [Route("api/tbl_Kullanici")]
  public class Tbl_KullaniciController : ApiController
  {

    private hfrEntities db = new hfrEntities();

    // POST: api/tbl_Kullanici
    [Route("api/yetkiGiris/tbl_Kullanici")]
    [HttpPost]
    public IHttpActionResult Gettbl_Kullanici()
    {

      var list = db.SP_KullaniciYetki();
      return Ok(list);
    }





    // PUT: api/tbl_Kullanici/5
    [ResponseType(typeof(void))]
    [HttpPut]
    public IHttpActionResult Puttbl_Kullanici(int id, tbl_Kullanici tbl_Kullanici)
    {
      if (!ModelState.IsValid)
      {
        return BadRequest(ModelState);
      }

      if (id != tbl_Kullanici.ID)
      {
        return BadRequest();
      }

      db.Entry(tbl_Kullanici).State = EntityState.Modified;

      try
      {
        db.SaveChanges();
      }
      catch (DbUpdateConcurrencyException)
      {
        if (!Tbl_KullaniciExists(id))
        {
          return NotFound();
        }
        else
        {
          throw;
        }
      }

      return StatusCode(HttpStatusCode.NoContent);
    }

    // POST: api/tbl_Kullanici

    [Route("api/kullaniciGiris/tbl_Kullanici")]
    [ResponseType(typeof(tbl_Kullanici))]
    [HttpPost]
    public IHttpActionResult Postbl_Kullanici(string KullaniciAdi, string KullaniciParola)
    {
      tbl_Kullanici tbl_Kullanici = db.tbl_Kullanici.SingleOrDefault(x => x.KullaniciAdi == KullaniciAdi && x.KullaniciParola == KullaniciParola);


      if (tbl_Kullanici == null)
      {
        return NotFound();
      }

      return Ok(tbl_Kullanici);
    }

    // DELETE: api/tbl_Kullanici/5
    [ResponseType(typeof(tbl_Kullanici))]
    [HttpDelete]
    public IHttpActionResult Deletetbl_Kullanici(int id)
    {
      tbl_Kullanici tbl_Kullanici = db.tbl_Kullanici.Find(id);
      if (tbl_Kullanici == null)
      {
        return NotFound();
      }

      db.tbl_Kullanici.Remove(tbl_Kullanici);
      db.SaveChanges();

      return Ok(tbl_Kullanici);
    }

    protected override void Dispose(bool disposing)
    {
      if (disposing)
      {
        db.Dispose();
      }
      base.Dispose(disposing);
    }

    private bool Tbl_KullaniciExists(int id)
    {
      return db.tbl_Kullanici.Count(e => e.ID == id) > 0;
    }
  }
}