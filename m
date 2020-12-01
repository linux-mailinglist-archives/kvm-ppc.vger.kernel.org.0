Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A3F2CA31C
	for <lists+kvm-ppc@lfdr.de>; Tue,  1 Dec 2020 13:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390526AbgLAMsE (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 1 Dec 2020 07:48:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390503AbgLAMsE (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 1 Dec 2020 07:48:04 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 216B9C0613CF
        for <kvm-ppc@vger.kernel.org>; Tue,  1 Dec 2020 04:47:24 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id z136so1447903iof.3
        for <kvm-ppc@vger.kernel.org>; Tue, 01 Dec 2020 04:47:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lr5SjPWb1+VHYhvL/XsMc+BHKjVk6o0dyPg3FwI5TcU=;
        b=WQ8dKkipBBHiFuH+lokOOWTrn9j1aPBup5y8MNKoJzWX5jaGHCuUUKT88E6+PK5y6E
         8cTt6nDtqhavG22jRdfnpStSE8QY09NMjyevVp39JCGFsNBcR6nyMPpAlPxpF5xmmZb6
         +jOCBRoHrhTVeFpBBaJfZ+OtDf+/Z+v5xElOwu1+gI7CECuwv+HyRRyxQ47bcaBUzmfn
         8rVd+Ad/C8yE6uZ7zs5KavsDUAC79XbYL7qyBUnXP9hlobhx9GdZEOGeu9edKjf5rpLZ
         nAfQ08a0jDoZN9DBcesd6txYJjZtu5qoPfDXC9GY3SvotkkdKGoVW5nwchQkqZYbxGgp
         UK3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lr5SjPWb1+VHYhvL/XsMc+BHKjVk6o0dyPg3FwI5TcU=;
        b=tK7rNNQm3tG7sNc7zz6WmRncCK4mlJMRx5EC7dQmhNvu9RU/qdSJaQY6B48GHeKRX5
         plxOr2JO4r8kTNbHmErEMJKLZe2UOKvQKFSVm8ibpUoyVJnF2+1b1/cD8w0N1zCSSTGp
         3frhpbQUjxlW0vAmsw/QDsOutVVikz0saQQoXu0iI1fwpOrEvqd9VimvbPdIrugRzNu+
         9tsQeGV5mr+YftbD+oWod2bqwHRfmw6u/a8frJeb1k5d+JpDEjh7vLk8GW/9YEW7Uctz
         AClXZ/mPUeJI542+JloBWpuRhfqiNDBZGe8GLMNwL/0eKWkJ2fAv+RvyRB6Akm3NX1pf
         zrSw==
X-Gm-Message-State: AOAM533gdKXNnsFbuhjY8h8cUapzr8AhYy5lkZ//0Hsns59h31VFnPEu
        6hE/NvHwFgPokmI7yDfYzTdHNnmoe5eHJXpn09o=
X-Google-Smtp-Source: ABdhPJwftegdi6n/pZ2eKVijBXnWtvgkZ/YqxQCZSjMKU+fmJbVal+4agqLvJtHhC/OEIWJ6bR8YdKqJ0yltUp0BS5s=
X-Received: by 2002:a05:6638:f89:: with SMTP id h9mr2341796jal.89.1606826843471;
 Tue, 01 Dec 2020 04:47:23 -0800 (PST)
MIME-Version: 1.0
References: <160682501436.2579014.14501834468510806255.stgit@lep8c.aus.stglabs.ibm.com>
In-Reply-To: <160682501436.2579014.14501834468510806255.stgit@lep8c.aus.stglabs.ibm.com>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Tue, 1 Dec 2020 13:47:12 +0100
Message-ID: <CAM9Jb+iPV470063QYq145znYW8CmqjNgdL=q6=3JXUJJt+z5gw@mail.gmail.com>
Subject: Re: [RFC PATCH] powerpc/papr_scm: Implement scm async flush
To:     Shivaprasad G Bhat <sbhat@linux.ibm.com>
Cc:     ellerman@au1.ibm.com,
        "Dave Jiang <dave.jiang@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>, Johannes Thumshirn
        <jthumshirn@suse.de>, Logan Gunthorpe" <aneesh.kumar@linux.ibm.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

> Tha patch implements SCM async-flush hcall and sets the
> ND_REGION_ASYNC capability when the platform device tree
> has "ibm,async-flush-required" set.

So, you are reusing the existing ND_REGION_ASYNC flag for the
hypercall based async flush with device tree discovery?

Out of curiosity, does virtio based flush work in ppc? Was just thinking
if we can reuse virtio based flush present in virtio-pmem? Or anything
else we are trying to achieve here?

Thanks,
Pankaj
>
> The below demonstration shows the map_sync behavior when
> ibm,async-flush-required is present in device tree.
> (https://github.com/avocado-framework-tests/avocado-misc-tests/blob/master/memory/ndctl.py.data/map_sync.c)
>
> The pmem0 is from nvdimm without async-flush-required,
> and pmem1 is from nvdimm with async-flush-required, mounted as
> /dev/pmem0 on /mnt1 type xfs (rw,relatime,attr2,dax=always,inode64,logbufs=8,logbsize=32k,noquota)
> /dev/pmem1 on /mnt2 type xfs (rw,relatime,attr2,dax=always,inode64,logbufs=8,logbsize=32k,noquota)
>
> #./mapsync /mnt1/newfile    ----> Without async-flush-required
> #./mapsync /mnt2/newfile    ----> With async-flush-required
> Failed to mmap  with Operation not supported
>
> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
> ---
> The HCALL semantics are in review, not final.

Any link of the discussion?

>
>  Documentation/powerpc/papr_hcalls.rst     |   14 ++++++++++
>  arch/powerpc/include/asm/hvcall.h         |    3 +-
>  arch/powerpc/platforms/pseries/papr_scm.c |   39 +++++++++++++++++++++++++++++
>  3 files changed, 55 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/powerpc/papr_hcalls.rst b/Documentation/powerpc/papr_hcalls.rst
> index 48fcf1255a33..cc310814f24c 100644
> --- a/Documentation/powerpc/papr_hcalls.rst
> +++ b/Documentation/powerpc/papr_hcalls.rst
> @@ -275,6 +275,20 @@ Health Bitmap Flags:
>  Given a DRC Index collect the performance statistics for NVDIMM and copy them
>  to the resultBuffer.
>
> +**H_SCM_ASYNC_FLUSH**
> +
> +| Input: *drcIndex*
> +| Out: *continue-token*
> +| Return Value: *H_SUCCESS, H_Parameter, H_P2, H_BUSY*
> +
> +Given a DRC Index Flush the data to backend NVDIMM device.
> +
> +The hcall returns H_BUSY when the flush takes longer time and the hcall needs
> +to be issued multiple times in order to be completely serviced. The
> +*continue-token* from the output to be passed in the argument list in
> +subsequent hcalls to the hypervisor until the hcall is completely serviced
> +at which point H_SUCCESS is returned by the hypervisor.
> +
>  References
>  ==========
>  .. [1] "Power Architecture Platform Reference"
> diff --git a/arch/powerpc/include/asm/hvcall.h b/arch/powerpc/include/asm/hvcall.h
> index c1fbccb04390..4a13074bc782 100644
> --- a/arch/powerpc/include/asm/hvcall.h
> +++ b/arch/powerpc/include/asm/hvcall.h
> @@ -306,7 +306,8 @@
>  #define H_SCM_HEALTH            0x400
>  #define H_SCM_PERFORMANCE_STATS 0x418
>  #define H_RPT_INVALIDATE       0x448
> -#define MAX_HCALL_OPCODE       H_RPT_INVALIDATE
> +#define H_SCM_ASYNC_FLUSH      0x4A0
> +#define MAX_HCALL_OPCODE       H_SCM_ASYNC_FLUSH
>
>  /* Scope args for H_SCM_UNBIND_ALL */
>  #define H_UNBIND_SCOPE_ALL (0x1)
> diff --git a/arch/powerpc/platforms/pseries/papr_scm.c b/arch/powerpc/platforms/pseries/papr_scm.c
> index 835163f54244..1f8c5153cb3d 100644
> --- a/arch/powerpc/platforms/pseries/papr_scm.c
> +++ b/arch/powerpc/platforms/pseries/papr_scm.c
> @@ -93,6 +93,7 @@ struct papr_scm_priv {
>         uint64_t block_size;
>         int metadata_size;
>         bool is_volatile;
> +       bool async_flush_required;
>
>         uint64_t bound_addr;
>
> @@ -117,6 +118,38 @@ struct papr_scm_priv {
>         size_t stat_buffer_len;
>  };
>
> +static int papr_scm_pmem_flush(struct nd_region *nd_region, struct bio *bio)
> +{
> +       unsigned long ret[PLPAR_HCALL_BUFSIZE];
> +       struct papr_scm_priv *p = nd_region_provider_data(nd_region);
> +       int64_t rc;
> +       uint64_t token = 0;
> +
> +       do {
> +               rc = plpar_hcall(H_SCM_ASYNC_FLUSH, ret, p->drc_index, token);
> +
> +               /* Check if we are stalled for some time */
> +               token = ret[0];
> +               if (H_IS_LONG_BUSY(rc)) {
> +                       msleep(get_longbusy_msecs(rc));
> +                       rc = H_BUSY;
> +               } else if (rc == H_BUSY) {
> +                       cond_resched();
> +               }
> +
> +       } while (rc == H_BUSY);
> +
> +       if (rc)
> +               dev_err(&p->pdev->dev, "flush error: %lld\n", rc);
> +       else
> +               dev_dbg(&p->pdev->dev, "flush drc 0x%x complete\n",
> +                       p->drc_index);
> +
> +       dev_dbg(&p->pdev->dev, "Flush call complete\n");
> +
> +       return rc;
> +}
> +
>  static LIST_HEAD(papr_nd_regions);
>  static DEFINE_MUTEX(papr_ndr_lock);
>
> @@ -943,6 +976,11 @@ static int papr_scm_nvdimm_init(struct papr_scm_priv *p)
>         ndr_desc.num_mappings = 1;
>         ndr_desc.nd_set = &p->nd_set;
>
> +       if (p->async_flush_required) {
> +               set_bit(ND_REGION_ASYNC, &ndr_desc.flags);
> +               ndr_desc.flush = papr_scm_pmem_flush;
> +       }
> +
>         if (p->is_volatile)
>                 p->region = nvdimm_volatile_region_create(p->bus, &ndr_desc);
>         else {
> @@ -1088,6 +1126,7 @@ static int papr_scm_probe(struct platform_device *pdev)
>         p->block_size = block_size;
>         p->blocks = blocks;
>         p->is_volatile = !of_property_read_bool(dn, "ibm,cache-flush-required");
> +       p->async_flush_required = of_property_read_bool(dn, "ibm,async-flush-required");
>
>         /* We just need to ensure that set cookies are unique across */
>         uuid_parse(uuid_str, (uuid_t *) uuid);
>
> _______________________________________________
> Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
> To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
