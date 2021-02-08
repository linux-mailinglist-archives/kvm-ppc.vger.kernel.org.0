Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97CED312ABE
	for <lists+kvm-ppc@lfdr.de>; Mon,  8 Feb 2021 07:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhBHGdJ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 8 Feb 2021 01:33:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbhBHGbS (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 8 Feb 2021 01:31:18 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB0CC061794
        for <kvm-ppc@vger.kernel.org>; Sun,  7 Feb 2021 22:30:30 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DYx3S5zWgz9sVR; Mon,  8 Feb 2021 17:30:28 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1612765828;
        bh=3z5T9UJRaU02SEuUWnxCg67jwmlHvzlscr5ZKg9Xvvw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JALvtq4wKY9GQURpsQywClnqBMnItqdZ5nKUoA1PupUYb+7sKNBAwO2Eavnjek5Nn
         BnMZm0Jq9L+ElDEHAMSG/C/Ykuj6bsjNuPTv2S90ULVJUjnj5TZxk1X18hhewH4eLX
         0rCQqnyDuhYjtgjWCVcHb1fUK/j04CgjOvQO22NA=
Date:   Mon, 8 Feb 2021 17:21:22 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Shivaprasad G Bhat <sbhat@linux.ibm.com>
Cc:     Greg Kurz <groug@kaod.org>, xiaoguangrong.eric@gmail.com,
        mst@redhat.com, imammedo@redhat.com, qemu-devel@nongnu.org,
        qemu-ppc@nongnu.org, linux-nvdimm@lists.01.org,
        aneesh.kumar@linux.ibm.com, kvm-ppc@vger.kernel.org,
        shivaprasadbhat@gmail.com, bharata@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [RFC Qemu PATCH v2 1/2] spapr: drc: Add support for async hcalls
 at the drc level
Message-ID: <20210208062122.GA40668@yekko.fritz.box>
References: <160674929554.2492771.17651548703390170573.stgit@lep8c.aus.stglabs.ibm.com>
 <160674938210.2492771.1728601884822491679.stgit@lep8c.aus.stglabs.ibm.com>
 <20201221130853.15c8ddfd@bahia.lan>
 <20201228083800.GN6952@yekko.fritz.box>
 <3b47312a-217f-8df5-0bfd-1a653598abad@linux.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <3b47312a-217f-8df5-0bfd-1a653598abad@linux.ibm.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 19, 2021 at 12:40:31PM +0530, Shivaprasad G Bhat wrote:
> Thanks for the comments!
>=20
>=20
> On 12/28/20 2:08 PM, David Gibson wrote:
>=20
> > On Mon, Dec 21, 2020 at 01:08:53PM +0100, Greg Kurz wrote:
> ...
> > > The overall idea looks good but I think you should consider using
> > > a thread pool to implement it. See below.
> > I am not convinced, however.  Specifically, attaching this to the DRC
> > doesn't make sense to me.  We're adding exactly one DRC related async
> > hcall, and I can't really see much call for another one.  We could
> > have other async hcalls - indeed we already have one for HPT resizing
> > - but attaching this to DRCs doesn't help for those.
>=20
> The semantics of the hcall made me think, if this is going to be
> re-usable for future if implemented at DRC level.

It would only be re-usable for operations that are actually connected
to DRCs.  It doesn't seem to me particularly likely that we'll ever
have more asynchronous hcalls that are also associated with DRCs.

> Other option
> is to move the async-hcall-state/list into the NVDIMMState structure
> in include/hw/mem/nvdimm.h and handle it with machine->nvdimms_state
> at a global level.

I'm ok with either of two options:

A) Implement this ad-hoc for this specific case, making whatever
simplifications you can based on this specific case.

B) Implement a general mechanism for async hcalls that is *not* tied
to DRCs.  Then use that for the existing H_RESIZE_HPT_PREPARE call as
well as this new one.

> Hope you are okay with using the pool based approach that Greg

Honestly a thread pool seems like it might be overkill for this
application.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmAg2F8ACgkQbDjKyiDZ
s5IHuA/9HyiCaZs3cWwZpR/QYIuwRGbtPEcvZlPwFFGfHwTmhbLPngp5pYbuO+tJ
Z9D61MwH1qNT1Q2XV8rW9moj+hTuJVjJZqFe05UApHqh2yq/OtHaZRUvZXYjtO9q
lF7sE9RnfPKs6eG9zWrqETIXyDq96SPoW1WZ6aryOUpfammRweNsl0YrXhWKv8Th
zJUczQMU3CuO/uANcw5hkVjH4amiKsGHXJnXqqeh7IQBx7WxVb3PN5jllxUOjI5b
Y6wxPllbvqf0n4I0NPYsY4juaaiLWXdO3PfMefvLVmx0NalyKyNiidTd3sVY0/UP
Thgc3PTuAij6v+PJbEcalHyEGuemE1QyGRCO7LDcVaw9N0Fr1NwtMpIkqtSyzhgO
U2fdn0Hi4OIuBac3CvEjXfbludNGbqIlsVQPvdtaBLJYgo1xvnWqKxUYv2YPF/kt
SDEehG2LvVk/5igzJ9sESyn8yROzXWJ3OfKJc2ivm6CcG/EMPGN87PqvjwRCmmoX
3IR2V5DLuIVNaPyIZSQuC60UJmOo52xGuGxtYH6cFQU2yFgiymFiQ9uHct4lZKrT
nv2YZL4JHX2rNZgk/mZtPoany4ilhWkbvpLWhDmFoOgfLOp7t3CqsD7XAu8u9FSH
pMaLTbLKIlrSSKsm+XiecWtFU7Zt1lhYHm7QIw73PLmw47jntos=
=gnLb
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
