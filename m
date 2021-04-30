Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B586A36FD5D
	for <lists+kvm-ppc@lfdr.de>; Fri, 30 Apr 2021 17:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhD3PJn (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 30 Apr 2021 11:09:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40605 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229532AbhD3PJl (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 30 Apr 2021 11:09:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619795332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9OmyH1RrzLEXuN3YYBOli7Z1fQZLCvh8PHugvMNpZ5c=;
        b=Gh4IrcAYQ1XjqmtayUNp3sHkPkmLBk1Dwv3LuJz2H+jzijfb5w/lNVj6pR8MnGB7ZKj0eS
        P57RpBU9XiWMqFPcnbLJLVlWOReWTD/Oj7fiOuS35GHttik7thtoDwq/2cpn+AHUuTJVY/
        xD/kw9aI+Wewpi+QbROKWREPXiwh76E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-TiW5yE8ZNgCa70ECbzFgHg-1; Fri, 30 Apr 2021 11:08:50 -0400
X-MC-Unique: TiW5yE8ZNgCa70ECbzFgHg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2FBB679EC2;
        Fri, 30 Apr 2021 15:08:47 +0000 (UTC)
Received: from localhost (ovpn-112-107.ams2.redhat.com [10.36.112.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0DFF35D9DD;
        Fri, 30 Apr 2021 15:08:41 +0000 (UTC)
Date:   Fri, 30 Apr 2021 16:08:40 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Shivaprasad G Bhat <sbhat@linux.ibm.com>, groug@kaod.org,
        qemu-ppc@nongnu.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, mst@redhat.com, imammedo@redhat.com,
        xiaoguangrong.eric@gmail.com, peter.maydell@linaro.org,
        eblake@redhat.com, qemu-arm@nongnu.org,
        richard.henderson@linaro.org, pbonzini@redhat.com,
        haozhong.zhang@intel.com, shameerali.kolothum.thodi@huawei.com,
        kwangwoo.lee@sk.com, armbru@redhat.com, qemu-devel@nongnu.org,
        linux-nvdimm@lists.01.org, kvm-ppc@vger.kernel.org,
        shivaprasadbhat@gmail.com, bharata@linux.vnet.ibm.com
Subject: Re: [PATCH v4 0/3] nvdimm: Enable sync-dax property for nvdimm
Message-ID: <YIwdeKzh/xJGX7AI@stefanha-x1.localdomain>
References: <161966810162.652.13723419108625443430.stgit@17be908f7c1c>
 <YIrW4bwbR1R0CWm/@stefanha-x1.localdomain>
 <433e352d-5341-520c-5c57-79650277a719@linux.ibm.com>
 <YIuHJkwkDiHONYwp@yekko>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="VstCjnrIpVAx4Zbs"
Content-Disposition: inline
In-Reply-To: <YIuHJkwkDiHONYwp@yekko>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


--VstCjnrIpVAx4Zbs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 30, 2021 at 02:27:18PM +1000, David Gibson wrote:
> On Thu, Apr 29, 2021 at 10:02:23PM +0530, Aneesh Kumar K.V wrote:
> > On 4/29/21 9:25 PM, Stefan Hajnoczi wrote:
> > > On Wed, Apr 28, 2021 at 11:48:21PM -0400, Shivaprasad G Bhat wrote:
> > > > The nvdimm devices are expected to ensure write persistence during =
power
> > > > failure kind of scenarios.
> > > >=20
> > > > The libpmem has architecture specific instructions like dcbf on POW=
ER
> > > > to flush the cache data to backend nvdimm device during normal writ=
es
> > > > followed by explicit flushes if the backend devices are not synchro=
nous
> > > > DAX capable.
> > > >=20
> > > > Qemu - virtual nvdimm devices are memory mapped. The dcbf in the gu=
est
> > > > and the subsequent flush doesn't traslate to actual flush to the ba=
ckend
> > > > file on the host in case of file backed v-nvdimms. This is addresse=
d by
> > > > virtio-pmem in case of x86_64 by making explicit flushes translatin=
g to
> > > > fsync at qemu.
> > > >=20
> > > > On SPAPR, the issue is addressed by adding a new hcall to
> > > > request for an explicit flush from the guest ndctl driver when the =
backend
> > > > nvdimm cannot ensure write persistence with dcbf alone. So, the app=
roach
> > > > here is to convey when the hcall flush is required in a device tree
> > > > property. The guest makes the hcall when the property is found, ins=
tead
> > > > of relying on dcbf.
> > >=20
> > > Sorry, I'm not very familiar with SPAPR. Why add a hypercall when the
> > > virtio-nvdimm device already exists?
> > >=20
> >=20
> > On virtualized ppc64 platforms, guests use papr_scm.ko kernel drive for
> > persistent memory support. This was done such that we can use one kernel
> > driver to support persistent memory with multiple hypervisors. To avoid
> > supporting multiple drivers in the guest, -device nvdimm Qemu command-l=
ine
> > results in Qemu using PAPR SCM backend. What this patch series does is =
to
> > make sure we expose the correct synchronous fault support, when we back=
 such
> > nvdimm device with a file.
> >=20
> > The existing PAPR SCM backend enables persistent memory support with the
> > help of multiple hypercall.
> >=20
> > #define H_SCM_READ_METADATA     0x3E4
> > #define H_SCM_WRITE_METADATA    0x3E8
> > #define H_SCM_BIND_MEM          0x3EC
> > #define H_SCM_UNBIND_MEM        0x3F0
> > #define H_SCM_UNBIND_ALL        0x3FC
> >=20
> > Most of them are already implemented in Qemu. This patch series impleme=
nts
> > H_SCM_FLUSH hypercall.
>=20
> The overall point here is that we didn't define the hypercall.  It was
> defined in order to support NVDIMM/pmem devices under PowerVM.  For
> uniformity between PowerVM and KVM guests, we want to support the same
> hypercall interface on KVM/qemu as well.

Okay, that's fine. Now Linux and QEMU have multiple ways of doing this,
but it's fair enough if it's an existing platform hypercall.

Stefan

--VstCjnrIpVAx4Zbs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmCMHXgACgkQnKSrs4Gr
c8hmgwf/XTtU49hZwgyXRnASpP3xkIjBSe84ajsAUZJpdfEhIcZBTOuQE3kZqu5G
1Q5Cl+nAJn8r7OfLQv6efwm4Nn4N1lsXf1pecLk1iemBIl9XxZg5pnYvYwIIn71I
bj2i/Sa8YOzP6NoSpiG8ydV57RC/fwVz8K1wolnS7qS6ysKs10ch/TfUYmsDq3Be
4mIXx9mh1cWxq5pBYeGMoA3ZEp8ja0jdr6LLqETClhDzP4R4pd0Oh6Zi07x4D0eH
JZzlQ8CUuomNX1ScXi6XAYGy3reRLeSLr2Rop6KptY3UN+dTQ+isXrUB4CX6fjbG
YAc8GbInVoW5oIYDPvNnr3wQWPmYZg==
=yVLh
-----END PGP SIGNATURE-----

--VstCjnrIpVAx4Zbs--

