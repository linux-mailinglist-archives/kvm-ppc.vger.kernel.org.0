Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6884C1882A8
	for <lists+kvm-ppc@lfdr.de>; Tue, 17 Mar 2020 12:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgCQL4w (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 17 Mar 2020 07:56:52 -0400
Received: from mail-qv1-f66.google.com ([209.85.219.66]:35296 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbgCQL4w (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 17 Mar 2020 07:56:52 -0400
Received: by mail-qv1-f66.google.com with SMTP id q73so1216713qvq.2
        for <kvm-ppc@vger.kernel.org>; Tue, 17 Mar 2020 04:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ezcaLzE+xMMW5k9+Lp3Fyb2v5+m1vlesVnD+8wIqvFk=;
        b=IqF/Pcn6Nw5T4vMcmTfGaEtbebh8d19TIxqJMpr9n/7ww13viixneJRo8yAFbrOmfF
         yi6gQx0fAlaDWh21kjKj5ucaecO2HtMyqm4zQjmaYbn9qmb7o8wevSYRehKm0LiRU8VO
         BSycWwfeQzFTeY9y3GLp2ZsXmrPN+MYAqq8r0p0PoqsvdUYABt3WTre7330EXu9VsyCT
         a0PmW2f0OysK4LylLGDsqjCxNyA5EKwiri2IPBjHLO00hBO15IPMZ4WZfsLN8I5jKx5y
         c8MsgopbvRu6Iql7pFUkjXgtxJ3ufw/0hJ9VOxF/4O+PKW8XFNgE+Ob+ZFAOc7o7Zue/
         PxXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ezcaLzE+xMMW5k9+Lp3Fyb2v5+m1vlesVnD+8wIqvFk=;
        b=JwHINx2IUWbzKHjPJm10V6M+hy/HTr12E3p08ATqvdC5/9v59Sd34zeDTJtCbMo4ei
         UIws0XZcfJ2NMg6ePtI/2ksyLG8HyLOtgwigyNs3BmdsIpLIcy9ZByFXuDZ9d+6QTdY4
         jy5s74OAiisvbAmLQ/++oDjWVk1M5pQiDw26EX9nja1UR1zNub1tOWETuVON9e+FCNNS
         Xzr7zX2fy7fUf+b4TnJVCK/2p4PBrW8UybD3C4ZMth3QpaV5ZSCncqVhHnL6onrsd1jV
         B3jmo9M6eqKL8HhhUAsYTwavhpxwT6GD0sgxmqDUhLi9sNkOXxcm4tZ/eWWzTTbZe0Iq
         kesA==
X-Gm-Message-State: ANhLgQ0/4E2rtxqiGGhdCFiTJ+r86LUcDSDwVpRfs8qlcSbgzJkS8vzA
        rP4bkmOFkFR/ZlPHfkIXgI+VHg==
X-Google-Smtp-Source: ADFU+vsg9TkFE/EUzCqf5ev0slQz4qmgYe2ZEFolT/sXe7p9PM9imp1X0/0EahO8T5ITCvrRw66fPw==
X-Received: by 2002:a05:6214:1628:: with SMTP id e8mr4546212qvw.81.1584446210477;
        Tue, 17 Mar 2020 04:56:50 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id l2sm1916228qtq.69.2020.03.17.04.56.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 17 Mar 2020 04:56:49 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jEAq1-0000my-Dc; Tue, 17 Mar 2020 08:56:49 -0300
Date:   Tue, 17 Mar 2020 08:56:49 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Ralph Campbell <rcampbell@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Jerome Glisse <jglisse@redhat.com>, kvm-ppc@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] mm: remove device private page support from
 hmm_range_fault
Message-ID: <20200317115649.GP20941@ziepe.ca>
References: <20200316175259.908713-1-hch@lst.de>
 <20200316175259.908713-3-hch@lst.de>
 <c099cc3c-c19f-9d61-4297-2e83df899ca4@nvidia.com>
 <20200316184935.GA25322@lst.de>
 <20200316200929.GB20010@ziepe.ca>
 <6de7ee97-45c7-b814-4dab-64e311dd86ce@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6de7ee97-45c7-b814-4dab-64e311dd86ce@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Mar 16, 2020 at 01:24:09PM -0700, Ralph Campbell wrote:

> The reason for it being backwards is that "normally" a device doesn't want
> the device private page to be faulted back to system memory, it wants to
> get the device private struct page so it can update its page table to point
> to the memory already in the device.

The "backwards" is you set the flag on input and never get it on
output, clear the flag in input and maybe get it on output.

Compare with valid or write which don't work that way.

> Also, a device like Nvidia's GPUs may have an alternate path for copying
> one GPU's memory to another (nvlink) without going through system memory
> so getting a device private struct page/PFN from hmm_range_fault() that isn't
> "owned" by the faulting GPU is useful.
> I agree that the current code isn't well tested or thought out for multiple devices
> (rdma, NVMe drives, GPUs, etc.) but it also ties in with peer-to-peer access via PCIe.

I think the series here is a big improvement. The GPU driver can set
owners that match the hidden cluster interconnect.

Jason
