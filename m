Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E7E28C3DD
	for <lists+kvm-ppc@lfdr.de>; Mon, 12 Oct 2020 23:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729474AbgJLVOU (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 12 Oct 2020 17:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727879AbgJLVOU (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 12 Oct 2020 17:14:20 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 117D6C0613D0
        for <kvm-ppc@vger.kernel.org>; Mon, 12 Oct 2020 14:14:20 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id lw21so25211128ejb.6
        for <kvm-ppc@vger.kernel.org>; Mon, 12 Oct 2020 14:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+E/x/oIv2ijFm2c9w4wv62KEKilXSc7t2Sb9ekDFptw=;
        b=Edzs632po8qKWgO3YwL1+/WtB+jp3E2Vu3gnBGR3UWRBL5wqJFRo1ZiouYvd1j7hdU
         Ixp12qDDQ78vGjE3OV/Lj7aXRatwmUPIiEL72PLClFVepJZovvzodPZGKEyxKZ9N3xzC
         /wGWB0EZXZiyIIdnohsdUSrkF2j3ljeNYyfJpgOxpuRecdCzWN9MlXi1HxwYn3AG3Y+j
         Ez7G84Q3qjBphLh3URy4AEUUlcVBgQlK2HwfEj6iwS7/1bTQlNl3JMbkVP+uoaeiZmrz
         LYmcl5Q9ho6uVvcilbmyEJCZ07yD0pc3UEOxk5BWy9nUQ1CumAEd4X0Eyuz1wzQmRqHk
         qAtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+E/x/oIv2ijFm2c9w4wv62KEKilXSc7t2Sb9ekDFptw=;
        b=Y7gJYffG7DHs1a4IUzeWgLMQazGJkImzzh4o7PL6CFEcxRBNV040r9eZ7uXagbZ0qD
         AwVFq2tnaSqeFyAClRUCYvtXlnSHXebfVExGUYgopI831ynLJIq6inFtv8PF1OfnfWGm
         2/8IhCQc1dU0k4NdCBvosMt5qqdOEUI+RUBcnHveCVT+NMOwlptg5bC1cj737DPScu1l
         ugzFzb93iBGeip11iHiSQp0VzS8HB2W268f/tt3XhzYiDIwiG1lw/rkkehSpEEjgpS9O
         GUB6bh0Yn2BhVeNF68dLxB7qojiTBEmVDGtu/dNmx17HPFmxnoWn9IApRw3tMHOSPT1H
         9h1Q==
X-Gm-Message-State: AOAM533Gw+i2wpOG0KJ3OAq9Q4YYiN3gndx7xUmH2eXIcaL3nBiwlSVm
        FiP6PLM7hwMD7G6bvF8Ztmln6w59mB1RVn9xkv3qEQ==
X-Google-Smtp-Source: ABdhPJz02OtB37X1Kl6Yw4VB2J5fzc4t6W8lA+4qFWxSxgpuA/gexEv+m5h1tqboEVvNq9alpAfTRLuAH8zdbpyQqLs=
X-Received: by 2002:a17:906:b88f:: with SMTP id hb15mr29759160ejb.45.1602537258704;
 Mon, 12 Oct 2020 14:14:18 -0700 (PDT)
MIME-Version: 1.0
References: <20201012174540.17328-1-rcampbell@nvidia.com>
In-Reply-To: <20201012174540.17328-1-rcampbell@nvidia.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 12 Oct 2020 14:14:07 -0700
Message-ID: <CAPcyv4ijD+=3rje1CfSG4XKuRNfuAWOui93NQV09NmBte_gc0w@mail.gmail.com>
Subject: Re: [PATCH v2] mm/hmm: make device private reference counts zero based
To:     Ralph Campbell <rcampbell@nvidia.com>
Cc:     Linux MM <linux-mm@kvack.org>, kvm-ppc@vger.kernel.org,
        nouveau@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ira Weiny <ira.weiny@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Jerome Glisse <jglisse@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Jason Gunthorpe <jgg@nvidia.com>, Zi Yan <ziy@nvidia.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Oct 12, 2020 at 10:46 AM Ralph Campbell <rcampbell@nvidia.com> wrote:
>
> ZONE_DEVICE struct pages have an extra reference count that complicates the
> code for put_page() and several places in the kernel that need to check the
> reference count to see that a page is not being used (gup, compaction,
> migration, etc.). Clean up the code so the reference count doesn't need to
> be treated specially for device private pages, leaving DAX as still being
> a special case.

Please no half-step to removing the special casing...

[..]
> +void free_zone_device_page(struct page *page)
> +{
> +       if (!is_device_private_page(page))
>                 return;

That seems too subtle to be acceptable to me. All ZONE_DEVICE pages
need to have the same relationship with respect to idle-ness and the
page reference count.
