Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17DB23C4137
	for <lists+kvm-ppc@lfdr.de>; Mon, 12 Jul 2021 04:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhGLCbk (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 11 Jul 2021 22:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbhGLCbk (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 11 Jul 2021 22:31:40 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF4FC0613DD
        for <kvm-ppc@vger.kernel.org>; Sun, 11 Jul 2021 19:28:52 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4GNSPb0W38z9sWc; Mon, 12 Jul 2021 12:28:51 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1626056931;
        bh=8rEjH0dzKExNB4Vfr0xwOB7DdDMZPgRZydmhVkbk2dY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YTeZbgZ1ryDErSt6ytQ/7m7gBKV093Byyi8hpUVjjMYSMtuMUyI8umldatRMyHtnt
         TBAa0+bEMwWb7q4zIQcBg08xfBwvbwKJM1Q1OnYhPDV8IhaFvEMzCC6eQqypeZI8mX
         ouy9SRxwNPV4m83Bm9xr9K0RY4YVnSMO1BUHCFiU=
Date:   Mon, 12 Jul 2021 12:28:43 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        aneesh.kumar@linux.ibm.com, npiggin@gmail.com, paulus@ozlabs.org,
        mpe@ellerman.id.au, farosas@linux.ibm.com
Subject: Re: [PATCH v8 3/6] KVM: PPC: Book3S HV: Add support for
 H_RPT_INVALIDATE
Message-ID: <YOuo2y4Wu5keCx5p@yekko>
References: <20210621085003.904767-1-bharata@linux.ibm.com>
 <20210621085003.904767-4-bharata@linux.ibm.com>
 <YOKNub8mS4U4iox0@yekko>
 <YOPpiLJlsEBtTmgt@in.ibm.com>
 <YOZ3zNsGbSoymVKI@yekko>
 <YOZ/FNW1K/nzaaEe@in.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="UpVcWh/rSfvRKJro"
Content-Disposition: inline
In-Reply-To: <YOZ/FNW1K/nzaaEe@in.ibm.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


--UpVcWh/rSfvRKJro
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 08, 2021 at 09:59:08AM +0530, Bharata B Rao wrote:
> On Thu, Jul 08, 2021 at 01:58:04PM +1000, David Gibson wrote:
> > On Tue, Jul 06, 2021 at 10:56:32AM +0530, Bharata B Rao wrote:
> > > On Mon, Jul 05, 2021 at 02:42:33PM +1000, David Gibson wrote:
> > > > On Mon, Jun 21, 2021 at 02:20:00PM +0530, Bharata B Rao wrote:
> > > > > diff --git a/arch/powerpc/include/asm/mmu_context.h b/arch/powerp=
c/include/asm/mmu_context.h
> > > > > index 4bc45d3ed8b0..b44f291fc909 100644
> > > > > --- a/arch/powerpc/include/asm/mmu_context.h
> > > > > +++ b/arch/powerpc/include/asm/mmu_context.h
> > > > > @@ -124,8 +124,17 @@ static inline bool need_extra_context(struct=
 mm_struct *mm, unsigned long ea)
> > > > > =20
> > > > >  #if defined(CONFIG_KVM_BOOK3S_HV_POSSIBLE) && defined(CONFIG_PPC=
_RADIX_MMU)
> > > > >  extern void radix_kvm_prefetch_workaround(struct mm_struct *mm);
> > > > > +void do_h_rpt_invalidate_prt(unsigned long pid, unsigned long lp=
id,
> > > > > +			     unsigned long type, unsigned long pg_sizes,
> > > > > +			     unsigned long start, unsigned long end);
> > > > >  #else
> > > > >  static inline void radix_kvm_prefetch_workaround(struct mm_struc=
t *mm) { }
> > > > > +static inline void do_h_rpt_invalidate_prt(unsigned long pid,
> > > > > +					   unsigned long lpid,
> > > > > +					   unsigned long type,
> > > > > +					   unsigned long pg_sizes,
> > > > > +					   unsigned long start,
> > > > > +					   unsigned long end) { }
> > > >=20
> > > > Since the only plausible caller is in KVM HV code, why do you need =
the
> > > > #else clause.
> > >=20
> > > The call to the above routine is prevented for non-radix guests
> > > in KVM HV code at runtime using kvm_is_radix() check and not by
> > > CONFIG_PPC_RADIX_MMU. Hence the #else version would be needed.
> >=20
> > kvm_is_radix() should evaluate to false at compile time if
> > !defined(CONFIG_PPC_RADIX_MMU), in which case, no you shouldn't need
> > the else version.
>=20
> At least in the latest mainline, I don't see the definition of
> kvm_is_radix() being conditional to CONFIG_PPC_RADIX_MMU.

That's probably worth fixing, then.

> Anyway this is what I see in practice if the #else version is
> removed and CONFIG_PPC_RADIX_MMU is turned off:
>=20
> arch/powerpc/kvm/book3s_hv.c: In function =E2=80=98kvmppc_h_rpt_invalidat=
e=E2=80=99:
> arch/powerpc/kvm/book3s_hv.c:983:2: error: implicit declaration of functi=
on =E2=80=98do_h_rpt_invalidate_prt=E2=80=99; did you mean =E2=80=98do_h_rp=
t_invalidate_pat=E2=80=99? [-Werror=3Dimplicit-function-declaration]
>   983 |  do_h_rpt_invalidate_prt(id, vcpu->kvm->arch.lpid,
>       |  ^~~~~~~~~~~~~~~~~~~~~~~
>       |  do_h_rpt_invalidate_pat

If you really do need the stub, it should probably be a BUG() rather
than a no-op, since this really never should get called if we don't
have radix.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--UpVcWh/rSfvRKJro
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmDrqNsACgkQbDjKyiDZ
s5IwwBAA5687QwkBNwS2OMCSRVUsdCp4NA6DvBXhVbfV2na34L7G3mnpA7B9EYIK
JBrJ6lwVcpYjFO28AXlg3s/yp0LjFJ69x9wskNqDjMkDoDC0jBf08RcJKmREjwwz
iK4gfKkE/2Du2Ev2r6MS5BumjPDyLlfbf22r/xDjPg8mkXNbtSp7FDDwVw5e1GhG
3B30E5kX72mOlRUi1eDr7WynsZ0Abm5YbcJ/bSopCkIfpcF6YLGLa2nrDihW2piI
f8CImXz2RhWX9jy38xo+SsUgG3EIrM8XZ3R3nKpZolv3V0OTzAXILMG8PRXgn+FJ
7lubPVg3muILkaI49lED42m2EcI1WsLwv5s42MoTGxyB5FAppBN9zfCJ+dSEk7I3
wN1gcg+/xtn+lWrH/OVf/kkm2v/vGdm9/H+aL//E4vkqFJ9rIfXENDE1o8nbxpH6
GsYlqz5T0TFfAhzMttzIG+K0K3dgEAvqVZl/uhAPHwFMTXXuO/zV3dlk3ltr1nTD
nY9Hl1pMzDJ0u61GSc+lfK0YYE0kCU3YdjL+XCLWtwxjw5WmYmRW7hucgSQPg2lb
r6WUOjScA6ye2kf6F8kM9fLNzjNRrUunjBVWNjUcLA34KVGBXrLf3bUYZVL5TgRR
/DEkinqUmERf8s5jFK+eEeZBvYNSJGY0uryqk4EB/5GJOqjhzjo=
=bZET
-----END PGP SIGNATURE-----

--UpVcWh/rSfvRKJro--
