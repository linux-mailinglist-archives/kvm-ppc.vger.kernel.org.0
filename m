Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE54B1052D8
	for <lists+kvm-ppc@lfdr.de>; Thu, 21 Nov 2019 14:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbfKUNYf (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 21 Nov 2019 08:24:35 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21310 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726342AbfKUNYf (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 21 Nov 2019 08:24:35 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xALDKHsK112587;
        Thu, 21 Nov 2019 08:24:19 -0500
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wact9fw38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Nov 2019 08:24:18 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xALDAUl7019567;
        Thu, 21 Nov 2019 13:24:16 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04wdc.us.ibm.com with ESMTP id 2wa8r7e4kb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Nov 2019 13:24:16 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xALDOFeb34275632
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Nov 2019 13:24:16 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE447112064;
        Thu, 21 Nov 2019 13:24:15 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2CC05112061;
        Thu, 21 Nov 2019 13:24:14 +0000 (GMT)
Received: from LeoBras (unknown [9.85.198.25])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 21 Nov 2019 13:24:13 +0000 (GMT)
Message-ID: <b8f93386fe124d2328b6f393845a3435fd3b94fa.camel@linux.ibm.com>
Subject: Re: [PATCH v2 1/4] powerpc/kvm/book3s: Fixes possible 'use after
 release' of kvm
From:   Leonardo Bras <leonardo@linux.ibm.com>
To:     Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date:   Thu, 21 Nov 2019 10:24:08 -0300
In-Reply-To: <c792fdc629d87f452d4348d33ab179df01d42017.camel@linux.ibm.com>
References: <20191107170258.36379-1-leonardo@linux.ibm.com>
         <20191107170258.36379-2-leonardo@linux.ibm.com>
         <87mud13d4r.fsf@mpe.ellerman.id.au>
         <c792fdc629d87f452d4348d33ab179df01d42017.camel@linux.ibm.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-jZ/Mz7t2a8V2KVKqQFTu"
User-Agent: Evolution 3.34.1 (3.34.1-1.fc31) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-21_03:2019-11-21,2019-11-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 suspectscore=0
 adultscore=0 mlxscore=0 bulkscore=0 clxscore=1015 spamscore=0
 malwarescore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911210123
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


--=-jZ/Mz7t2a8V2KVKqQFTu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2019-11-14 at 15:43 -0300, Leonardo Bras wrote:
> > If the kvm_put_kvm() you've moved actually caused the last
> > reference
> > to
> > be dropped that would mean that our caller had passed us a kvm
> > struct
> > without holding a reference to it, and that would be a bug in our
> > caller.
> >=20
>=20
> So, there is no chance that between this function's kvm_get_kvm()
> and=20
> kvm_put_kvm(), another thread can decrease this reference counter?

I am probably missing something here, could you please help me
understand that?

> > Or put another way, it would mean the mutex_lock() above could
> > already
> > be operating on a freed kvm struct.
> >=20
> > The kvm_get_kvm() prior to the anon_inode_getfd() is to account for
> > the
> > reference that's held by the `stt` struct, and dropped in
> > kvm_spapr_tce_release().
> >=20
> > So although this patch isn't wrong, the explanation is not
> > accurate.
> >=20
> > cheers
>=20
> Kind regards

Best regards,

--=-jZ/Mz7t2a8V2KVKqQFTu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEMdeUgIzgjf6YmUyOlQYWtz9SttQFAl3Wj/gACgkQlQYWtz9S
ttQQhxAA3MFdSCc3LtKuX3KaXXl0ANgOzVWMrxMN5oUiiwIRPLZT33KNI6g8ugpT
lWqOESy9bYgPUt8c7dO/kKVMEAgh82MAG1NzLbyFFGuijeClhC9YI6rTl7/3AdFr
t/ovi/ofIJomu/P5rLXZmFGslc5CbHUHJ6De8ncngwG2ZZ5We7vQDnCmdJa7l+XW
TTPaTQBNdrOWBDOqV0kVz35pOktKSxHyjQ36myP/wmEzaOmTn4lKmKpz4cv287dD
8TcoXv2IPgUgEmSWPC1pGF2tyc4cHXL5rzirdNuREr4iKezhdWrOecbp5A1G/+tN
Y4d65+H073/Ni+DbhsQBrypmAKdskfrSFx8N3e3Kn1DTxlBonHq3xdTB9cmIDfEg
PNqH79orqQoTzJqiLCGcPQKTAtS9mFKNWJJvi7lhB7JhBDdP0prjUmO5rroiub7f
TMiAqRKYgvWRkXm+Q+Fnn1CM+j1s/YmwLCnz2hLjyY9h0FNzqHMIB1o4DMDTEn9m
ysZqENLzZcLZUne36/EPu9Z0J8KJ6GnvxVbkgydiA2CdyIUm4cPkDAaXuPY8B+Qd
/CcFeXAouKj4jeTYKvxabyJ55XJPbUwt4EuPovqufF3FPyGRr+YiGeJ6VZfLnL4I
/AmcpHnSqZNKrPcokrZc197LhwuQdHEwI+UJ/s+wDs9KxGdfcqM=
=y4OU
-----END PGP SIGNATURE-----

--=-jZ/Mz7t2a8V2KVKqQFTu--

