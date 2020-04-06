Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB02C1A012E
	for <lists+kvm-ppc@lfdr.de>; Tue,  7 Apr 2020 00:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgDFWjp (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 6 Apr 2020 18:39:45 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:36805 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbgDFWjp (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 6 Apr 2020 18:39:45 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 48x57z0wMQz9sQx; Tue,  7 Apr 2020 08:39:43 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1586212783;
        bh=L+6BwS8iTSp76qfstt4C3QhyP38Szgs0Xg0WTZ8BuC4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ndLxKC3jsJ1i5VxzQMVcVXLbDIIYCOh7zwnQkeqRO1j4Z6mAi8a5rwVBw2zJ31Ghp
         cXONh0azmLHB7kvG46E5VtsyzyPMGIjSIgYtkpS0eVC+AnYS7Vu5yEfCqTycU9RDrO
         MA6+tdF+5iebFTdghG8XjzHkMqZyRVekejr5hZf0=
Date:   Mon, 6 Apr 2020 19:58:19 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Gautham R Shenoy <ego@linux.vnet.ibm.com>
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Michael Neuling <mikey@neuling.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@ozlabs.org>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linuxppc-dev@ozlabs.org
Subject: Re: [RFC/PATCH  2/3] pseries/kvm: Clear PSSCR[ESL|EC] bits before
 guest entry
Message-ID: <20200406095819.GC2945@umbus.fritz.box>
References: <1585656658-1838-1-git-send-email-ego@linux.vnet.ibm.com>
 <1585656658-1838-3-git-send-email-ego@linux.vnet.ibm.com>
 <1585880159.w3mc2nk6h3.astroid@bobo.none>
 <20200403093103.GA20293@in.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="pAwQNkOnpTn9IO2O"
Content-Disposition: inline
In-Reply-To: <20200403093103.GA20293@in.ibm.com>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


--pAwQNkOnpTn9IO2O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 03, 2020 at 03:01:03PM +0530, Gautham R Shenoy wrote:
> On Fri, Apr 03, 2020 at 12:20:26PM +1000, Nicholas Piggin wrote:
> > Gautham R. Shenoy's on March 31, 2020 10:10 pm:
> > > From: "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>
> > >=20
> > > ISA v3.0 allows the guest to execute a stop instruction. For this, the
> > > PSSCR[ESL|EC] bits need to be cleared by the hypervisor before
> > > scheduling in the guest vCPU.
> > >=20
> > > Currently we always schedule in a vCPU with PSSCR[ESL|EC] bits
> > > set. This patch changes the behaviour to enter the guest with
> > > PSSCR[ESL|EC] bits cleared. This is a RFC patch where we
> > > unconditionally clear these bits. Ideally this should be done
> > > conditionally on platforms where the guest stop instruction has no
> > > Bugs (starting POWER9 DD2.3).
> >=20
> > How will guests know that they can use this facility safely after your
> > series? You need both DD2.3 and a patched KVM.
>=20
>=20
> Yes, this is something that isn't addressed in this series (mentioned
> in the cover letter), which is a POC demonstrating that the stop0lite
> state in guest works.
>=20
> However, to answer your question, this is the scheme that I had in
> mind :
>=20
> OPAL:
>    On Procs >=3D DD2.3 : we publish a dt-cpu-feature "idle-stop-guest"
>=20
> Hypervisor Kernel:
>     1. If "idle-stop-guest" dt-cpu-feature is discovered, then
>        we set bool enable_guest_stop =3D true;
>=20
>     2. During KVM guest entry, clear PSSCR[ESL|EC] iff
>        enable_guest_stop =3D=3D true.
>=20
>     3. In kvm_vm_ioctl_check_extension(), for a new capability
>        KVM_CAP_STOP, return true iff enable_guest_top =3D=3D true.
>=20
> QEMU:
>    Check with the hypervisor if KVM_CAP_STOP is present. If so,
>    indicate the presence to the guest via device tree.

Nack.  Presenting different capabilities to the guest depending on
host capabilities (rather than explicit options) is never ok.  It
means that depending on the system you start on you may or may not be
able to migrate to other systems that you're supposed to be able to,

> Guest Kernel:
>    Check for the presence of guest stop state support in
>    device-tree. If available, enable the stop0lite in the cpuidle
>    driver.=20
>   =20
>=20
> We still have a challenge of migrating a guest which started on a
> hypervisor supporting guest stop state to a hypervisor without it.
> The target hypervisor should atleast have Patch 1 of this series, so
> that we don't crash the guest.
>=20
> >=20
> > >=20
> > > Signed-off-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
> > > ---
> > >  arch/powerpc/kvm/book3s_hv.c            |  2 +-
> > >  arch/powerpc/kvm/book3s_hv_rmhandlers.S | 25 +++++++++++++----------=
--
> > >  2 files changed, 14 insertions(+), 13 deletions(-)
> > >=20
> > > diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_h=
v.c
> > > index cdb7224..36d059a 100644
> > > --- a/arch/powerpc/kvm/book3s_hv.c
> > > +++ b/arch/powerpc/kvm/book3s_hv.c
> > > @@ -3424,7 +3424,7 @@ static int kvmhv_load_hv_regs_and_go(struct kvm=
_vcpu *vcpu, u64 time_limit,
> > >  	mtspr(SPRN_IC, vcpu->arch.ic);
> > >  	mtspr(SPRN_PID, vcpu->arch.pid);
> > > =20
> > > -	mtspr(SPRN_PSSCR, vcpu->arch.psscr | PSSCR_EC |
> > > +	mtspr(SPRN_PSSCR, (vcpu->arch.psscr  & ~(PSSCR_EC | PSSCR_ESL)) |
> > >  	      (local_paca->kvm_hstate.fake_suspend << PSSCR_FAKE_SUSPEND_LG=
));
> > > =20
> > >  	mtspr(SPRN_HFSCR, vcpu->arch.hfscr);
> > > diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/k=
vm/book3s_hv_rmhandlers.S
> > > index dbc2fec..c2daec3 100644
> > > --- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> > > +++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> > > @@ -823,6 +823,18 @@ END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_207S)
> > >  	mtspr	SPRN_PID, r7
> > >  	mtspr	SPRN_WORT, r8
> > >  BEGIN_FTR_SECTION
> > > +	/* POWER9-only registers */
> > > +	ld	r5, VCPU_TID(r4)
> > > +	ld	r6, VCPU_PSSCR(r4)
> > > +	lbz	r8, HSTATE_FAKE_SUSPEND(r13)
> > > +	lis 	r7, (PSSCR_EC | PSSCR_ESL)@h /* Allow guest to call stop */
> > > +	andc	r6, r6, r7
> > > +	rldimi	r6, r8, PSSCR_FAKE_SUSPEND_LG, 63 - PSSCR_FAKE_SUSPEND_LG
> > > +	ld	r7, VCPU_HFSCR(r4)
> > > +	mtspr	SPRN_TIDR, r5
> > > +	mtspr	SPRN_PSSCR, r6
> > > +	mtspr	SPRN_HFSCR, r7
> > > +FTR_SECTION_ELSE
> >=20
> > Why did you move these around? Just because the POWER9 section became
> > larger than the other?
>=20
> Yes.
>=20
> >=20
> > That's a real wart in the instruction patching implementation, I think
> > we can fix it by padding with nops in the macros.
> >=20
> > Can you just add the additional required nops to the top branch without
> > changing them around for this patch, so it's easier to see what's going
> > on? The end result will be the same after patching. Actually changing
> > these around can have a slight unintended consequence in that code that
> > runs before features were patched will execute the IF code. Not a
> > problem here, but another reason why the instruction patching=20
> > restriction is annoying.
>=20
> Sure, I will repost this patch with additional nops instead of
> moving them around.
>=20
> >=20
> > Thanks,
> > Nick
> >=20
> > >  	/* POWER8-only registers */
> > >  	ld	r5, VCPU_TCSCR(r4)
> > >  	ld	r6, VCPU_ACOP(r4)
> > > @@ -833,18 +845,7 @@ BEGIN_FTR_SECTION
> > >  	mtspr	SPRN_CSIGR, r7
> > >  	mtspr	SPRN_TACR, r8
> > >  	nop
> > > -FTR_SECTION_ELSE
> > > -	/* POWER9-only registers */
> > > -	ld	r5, VCPU_TID(r4)
> > > -	ld	r6, VCPU_PSSCR(r4)
> > > -	lbz	r8, HSTATE_FAKE_SUSPEND(r13)
> > > -	oris	r6, r6, PSSCR_EC@h	/* This makes stop trap to HV */
> > > -	rldimi	r6, r8, PSSCR_FAKE_SUSPEND_LG, 63 - PSSCR_FAKE_SUSPEND_LG
> > > -	ld	r7, VCPU_HFSCR(r4)
> > > -	mtspr	SPRN_TIDR, r5
> > > -	mtspr	SPRN_PSSCR, r6
> > > -	mtspr	SPRN_HFSCR, r7
> > > -ALT_FTR_SECTION_END_IFCLR(CPU_FTR_ARCH_300)
> > > +ALT_FTR_SECTION_END_IFSET(CPU_FTR_ARCH_300)
> > >  8:
> > > =20
> > >  	ld	r5, VCPU_SPRG0(r4)
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--pAwQNkOnpTn9IO2O
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl6K/TgACgkQbDjKyiDZ
s5KnqhAAof6uPdQc0eK9Cv1MTodmJ4laYdEhgnJx1OMLGLdhAg4DAn7ODiDAtwnk
GrNxnL9PM0VdmtICV93KO/WXBXdBY6Dfuw7af0XYYQB+yw6KWU1lgD0QrcwTkDRw
ONFiSiebB/MnPTJEd0kGi4+kVo4o/77Csh90jTn5pY2Yz02/V2IB9imFFTx1L8E+
J1jkPQgk4ilaBr4FX6mBoBP16aiCHmUXsaOeaEgmgUCu9VauWzn25dVDBZy/qvre
QitLPjEjFrHjfwZXB1xC47y8fCWD5xIr7eTHmqidlydlMmIf2LHDLZ57coh5g9H3
Dbc/2Ua4cVSwq38GgLiG5B9zNo/eYmHoxk4bM7uDEUnab1SPaSAIetuCkiv2r6zh
WadeJEPs136XVFExK5Td2Qpatu/nvlVQFF5UVbjRTSuvGC3p7Kvl1wxLQS3esUKS
fTHTz+kCQmVxzu1Ls8sQUG3GBgxm+Go/EDvtIeVZ8s8HvIES4ZTimz6BMwSEa+k2
haHAcrsL8gwLrU1UaUmvXZa9a5yw4kCXXKAtuG4tTmOjcDYMXyA88bVaeU274JFC
vciPzopqoGfw2gIyI8GfDO6PMt7ZvD7kWgGTXqNueQuxTxUcaK6yzQBnXAHEipM6
QBUgj7uyceeu9anehjhU9KBvN2GxZ6Gr7y+Jnk98JWb8tWQMeqU=
=pGx+
-----END PGP SIGNATURE-----

--pAwQNkOnpTn9IO2O--
