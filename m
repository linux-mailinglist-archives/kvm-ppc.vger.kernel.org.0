Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7B15179CD7
	for <lists+kvm-ppc@lfdr.de>; Thu,  5 Mar 2020 01:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388513AbgCEA3m (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 4 Mar 2020 19:29:42 -0500
Received: from ozlabs.org ([203.11.71.1]:48575 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388509AbgCEA3l (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 4 Mar 2020 19:29:41 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 48Xs836Hz7z9sRR; Thu,  5 Mar 2020 11:29:39 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1583368179;
        bh=5xu/dzFuNwVikXTzBhBcxMlmER91thjs/7c43G7N2qU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fVDV3f2oU8QzPzeza4hCjA/gjhFcU6eNxr/IRVoMZyAXS0yz7FClzew+zjwmG5VC4
         gdqdOiyO4viO1+SiCAzLFrhyF1EF0YcJ4X+u5ZIAwCbo8Hw5Y+RG5wJO7ZrYKfYh/z
         zZAdyemXORp2N+u1MYOKRV7DGImEv8/J6z0kq9WI=
Date:   Thu, 5 Mar 2020 10:55:45 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@fr.ibm.com>
Cc:     Ram Pai <linuxram@us.ibm.com>, Greg Kurz <groug@kaod.org>,
        linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        mpe@ellerman.id.au, bauerman@linux.ibm.com, andmike@linux.ibm.com,
        sukadev@linux.vnet.ibm.com, aik@ozlabs.ru, paulus@ozlabs.org
Subject: Re: [RFC PATCH v1] powerpc/prom_init: disable XIVE in Secure VM.
Message-ID: <20200304235545.GE593957@umbus.fritz.box>
References: <1582962844-26333-1-git-send-email-linuxram@us.ibm.com>
 <20200302233240.GB35885@umbus.fritz.box>
 <8f0c3d41-d1f9-7e6d-276b-b95238715979@fr.ibm.com>
 <20200303170205.GA5416@oc0525413822.ibm.com>
 <20200303184520.632be270@bahia.home>
 <20200303185645.GB5416@oc0525413822.ibm.com>
 <20200304115948.7b2dfe10@bahia.home>
 <20200304153727.GH5416@oc0525413822.ibm.com>
 <08269906-db11-b80c-0e67-777ab0aaa9bd@fr.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5xSkJheCpeK0RUEJ"
Content-Disposition: inline
In-Reply-To: <08269906-db11-b80c-0e67-777ab0aaa9bd@fr.ibm.com>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


--5xSkJheCpeK0RUEJ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 04, 2020 at 04:56:09PM +0100, C=E9dric Le Goater wrote:
> [ ... ]
>=20
> > (1) applied the patch which shares the EQ-page with the hypervisor.
> > (2) set "kernel_irqchip=3Doff"
> > (3) set "ic-mode=3Dxive"
>=20
> you don't have to set the interrupt mode. xive should be negotiated
> by default.
>=20
> > (4) set "svm=3Don" on the kernel command line.
> > (5) no changes to the hypervisor and ultravisor.
> >=20
> > And Boom it works!.   So you were right.
>=20
> Excellent.
> =20
> > I am sending out the patch for (1) above ASAP.
>=20
> Next step, could you please try to do the same with the TIMA and ESB pfn ?
> and use KVM.

I'm a bit confused by this.  Aren't the TIMA and ESB pages essentially
IO pages, rather than memory pages from the guest's point of view?  I
assume only memory pages are protected with PEF - I can't even really
see what protecting an IO page would even mean.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--5xSkJheCpeK0RUEJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl5gP/8ACgkQbDjKyiDZ
s5JaxxAAnwIyf0WXC5YzeSjk1V+AVuxL+cTigsJ+1YnlFgSAXo34iO5iCZbKag92
Kz7HmDKLZwtomQ2WFrauUcg32Ui2e5xnfExVEjVQl9rm+8SxF4htjORiCVCkvWXt
mnYEtW4u2nGtMKp90mKysXxKXC+mPAjq1vwgSl5/Jo6pLhpDvagUsxDH3pYDodlo
8ie2CkmOGDOTVmAD9S+cRn/n8DBz4mw82TaWoL2Njes6BqLbkxjjpFW4y7pojHW/
DHzq8f3q+qfoKG3DNwoLACvgTP5XLBlnqBJ0Sds5jmWz1wjHfQxcSP8Qn3g2H+DF
EcA7w64YHAtLzsOrcAxXSkrG5nowiE6sgSKDskVuBFH59lo+5RgaWEJCVO6Nc5sp
HriPGmRJAceJHtNTPF8sbcMAwNSwkfRYcpUTs4dmVUHUg1zfIsn0DorALL9/xy8a
w6yDVfgf6yQGlojatQ7Wz3a43s2JalFf/zCODealfJJlStlCeY5Uw1bX11WdLbJi
AnPygR6PS1FMbEUTM4BJkbICQ3rg2652IpsZd9rsHolEXk1yEpJlbQXpByUETsNq
8tqjzb04gm/a9wBgsKrU1p3hAFJ4sGPsoXj+u17iZfOs9Xb5I4i6YOgXv+6J0OYi
tjSW+Dmu8EImuTpULYbt1j1TjRU9oU/PzN5Jnzi/+uEakQxi3Nc=
=DN2A
-----END PGP SIGNATURE-----

--5xSkJheCpeK0RUEJ--
