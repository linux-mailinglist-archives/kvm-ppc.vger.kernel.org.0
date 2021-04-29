Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E51136EDB4
	for <lists+kvm-ppc@lfdr.de>; Thu, 29 Apr 2021 17:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233132AbhD2P4R (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 29 Apr 2021 11:56:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43773 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232004AbhD2P4Q (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 29 Apr 2021 11:56:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619711729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gV1rD9bP2auaigdAbuGR4mySJTtzY5Cye9xn+YBFw4I=;
        b=ale+RNCBzti8iTEyMH0IiXc8pSPECAbPhzHnwRtN7MmK2OR6Y19Va8KmPgVUugp8Eip+dG
        VS39VFlNfhBHY1xkDtPdkCUJLHEPtCxTYMa0sMt0WzaPhBR2TKwXk3sIOps5e3ioAceQN5
        Q5GEtS+c+4jJPH1DcV4nI6llyPDRyBI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-548-RWF37mhfMXigVq3nHW7iqA-1; Thu, 29 Apr 2021 11:55:27 -0400
X-MC-Unique: RWF37mhfMXigVq3nHW7iqA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E6B08026BB;
        Thu, 29 Apr 2021 15:55:25 +0000 (UTC)
Received: from localhost (ovpn-115-28.ams2.redhat.com [10.36.115.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E21A319C59;
        Thu, 29 Apr 2021 15:55:14 +0000 (UTC)
Date:   Thu, 29 Apr 2021 16:55:13 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Shivaprasad G Bhat <sbhat@linux.ibm.com>
Cc:     david@gibson.dropbear.id.au, groug@kaod.org, qemu-ppc@nongnu.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        imammedo@redhat.com, xiaoguangrong.eric@gmail.com,
        peter.maydell@linaro.org, eblake@redhat.com, qemu-arm@nongnu.org,
        richard.henderson@linaro.org, pbonzini@redhat.com,
        haozhong.zhang@intel.com, shameerali.kolothum.thodi@huawei.com,
        kwangwoo.lee@sk.com, armbru@redhat.com, qemu-devel@nongnu.org,
        aneesh.kumar@linux.ibm.com, linux-nvdimm@lists.01.org,
        kvm-ppc@vger.kernel.org, shivaprasadbhat@gmail.com,
        bharata@linux.vnet.ibm.com
Subject: Re: [PATCH v4 0/3] nvdimm: Enable sync-dax property for nvdimm
Message-ID: <YIrW4bwbR1R0CWm/@stefanha-x1.localdomain>
References: <161966810162.652.13723419108625443430.stgit@17be908f7c1c>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Rcrw00CWvSVPCG9y"
Content-Disposition: inline
In-Reply-To: <161966810162.652.13723419108625443430.stgit@17be908f7c1c>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


--Rcrw00CWvSVPCG9y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 28, 2021 at 11:48:21PM -0400, Shivaprasad G Bhat wrote:
> The nvdimm devices are expected to ensure write persistence during power
> failure kind of scenarios.
>=20
> The libpmem has architecture specific instructions like dcbf on POWER
> to flush the cache data to backend nvdimm device during normal writes
> followed by explicit flushes if the backend devices are not synchronous
> DAX capable.
>=20
> Qemu - virtual nvdimm devices are memory mapped. The dcbf in the guest
> and the subsequent flush doesn't traslate to actual flush to the backend
> file on the host in case of file backed v-nvdimms. This is addressed by
> virtio-pmem in case of x86_64 by making explicit flushes translating to
> fsync at qemu.
>=20
> On SPAPR, the issue is addressed by adding a new hcall to
> request for an explicit flush from the guest ndctl driver when the backend
> nvdimm cannot ensure write persistence with dcbf alone. So, the approach
> here is to convey when the hcall flush is required in a device tree
> property. The guest makes the hcall when the property is found, instead
> of relying on dcbf.

Sorry, I'm not very familiar with SPAPR. Why add a hypercall when the
virtio-nvdimm device already exists?

Stefan

--Rcrw00CWvSVPCG9y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmCK1uEACgkQnKSrs4Gr
c8g/QAf/Zl3J7k2z3nQpWi/HcgKIqmiZ/gYlHxU610TnzxB0pWJfprNzeuJEWeaC
tT9RloGdmS+KmKkKjX7LQplDEry2hc6tEbyUfj3YemUW5Lz8gouaagtSkfLOFsVb
Gpd74EcslwzSzeTmaczXTLP6MVsNaLBJx94C2/tIouGbAZwHcXSWPk/czqFm3YfL
1Zddp77kaNiEOxk62DmL2+iW5NHzNNNzQZyMOod6el05nvuCQrobqzu3HuJ9LklE
CWyi3GbrFLVIsB/xFKIGykaCOaQLpdc/KP6ckdN4mWTStJv9DUCd4ypomrhd1utY
NaKyqhVKEC95PHCEz1YZk9BP8SwUlg==
=jrRj
-----END PGP SIGNATURE-----

--Rcrw00CWvSVPCG9y--

