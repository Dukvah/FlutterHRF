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
    public class Tbl_YetkiGrupController : ApiController
    {
        private hfrEntities db = new hfrEntities();

        // GET: api/tbl_YetkiGrup
        public IQueryable<tbl_YetkiGrup> Gettbl_YetkiGrup()
        {
            return db.tbl_YetkiGrup;
        }

        // GET: api/tbl_YetkiGrup/5
        [ResponseType(typeof(tbl_YetkiGrup))]
        public IHttpActionResult Gettbl_YetkiGrup(int id)
        {
            tbl_YetkiGrup tbl_YetkiGrup = db.tbl_YetkiGrup.Find(id);
            if (tbl_YetkiGrup == null)
            {
                return NotFound();
            }

            return Ok(tbl_YetkiGrup);
        }

        // PUT: api/tbl_YetkiGrup/5
        [ResponseType(typeof(void))]
        public IHttpActionResult Puttbl_YetkiGrup(int id, tbl_YetkiGrup tbl_YetkiGrup)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != tbl_YetkiGrup.ID)
            {
                return BadRequest();
            }

            db.Entry(tbl_YetkiGrup).State = EntityState.Modified;

            try
            {
                db.SaveChanges();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!Tbl_YetkiGrupExists(id))
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

        // POST: api/tbl_YetkiGrup
        [ResponseType(typeof(tbl_YetkiGrup))]
      
        public IHttpActionResult Posttbl_YetkiGrup(tbl_YetkiGrup tbl_YetkiGrup)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.tbl_YetkiGrup.Add(tbl_YetkiGrup);
            db.SaveChanges();

            return CreatedAtRoute("DefaultApi", new { id = tbl_YetkiGrup.ID }, tbl_YetkiGrup);
        }

        // DELETE: api/tbl_YetkiGrup/5
        [ResponseType(typeof(tbl_YetkiGrup))]
        public IHttpActionResult Deletetbl_YetkiGrup(int id)
        {
            tbl_YetkiGrup tbl_YetkiGrup = db.tbl_YetkiGrup.Find(id);
            if (tbl_YetkiGrup == null)
            {
                return NotFound();
            }

            db.tbl_YetkiGrup.Remove(tbl_YetkiGrup);
            db.SaveChanges();

            return Ok(tbl_YetkiGrup);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool Tbl_YetkiGrupExists(int id)
        {
            return db.tbl_YetkiGrup.Count(e => e.ID == id) > 0;
        }
    }
}