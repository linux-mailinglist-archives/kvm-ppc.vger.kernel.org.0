Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D3326D000
	for <lists+kvm-ppc@lfdr.de>; Thu, 17 Sep 2020 02:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbgIQAfy (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 16 Sep 2020 20:35:54 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:3924 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgIQAfx (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 16 Sep 2020 20:35:53 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f62af5b0000>; Wed, 16 Sep 2020 17:35:39 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 16 Sep 2020 17:35:52 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 16 Sep 2020 17:35:52 -0700
Received: from rcampbell-dev.nvidia.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 17 Sep
 2020 00:35:49 +0000
Subject: Re: [PATCH] mm: remove extra ZONE_DEVICE struct page refcount
To:     Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>
CC:     Linux MM <linux-mm@kvack.org>, <kvm-ppc@vger.kernel.org>,
        <nouveau@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ira Weiny <ira.weiny@intel.com>,
        "Matthew Wilcox" <willy@infradead.org>,
        Jerome Glisse <jglisse@redhat.com>,
        "John Hubbard" <jhubbard@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        "Jason Gunthorpe" <jgg@nvidia.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Zi Yan <ziy@nvidia.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20200914224509.17699-1-rcampbell@nvidia.com>
 <CAPcyv4gVJuWsOtejrKvWgByq=c1niwQOZ0HHYaSo4h6vc-Xw+Q@mail.gmail.com>
 <20200916061054.GC7321@lst.de>
X-Nvconfidentiality: public
From:   Ralph Campbell <rcampbell@nvidia.com>
Message-ID: <4842558d-9626-0452-6398-c2fe39a9a31c@nvidia.com>
Date:   Wed, 16 Sep 2020 17:35:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200916061054.GC7321@lst.de>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600302939; bh=8LDzccoActo8nWBlttLgmhuoOW1Z2c2MD7demjEypqQ=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Q/uj+ryQtb/eBmR3IpGzH7gC57BnghlEPBnv1cfvPBKIfxMtly6SFT3dGaW7ig7v7
         IqeBEul8UUEhPQWsnDmUGbW5BOBMEwHoFyICyTqId2jjJN+DWzVTtT8r7U9JWuI3ty
         F/SQQ5yVqGc/dogmTjyTpLXc03CLbAeKQ09g6JU8uxdWledt63qLshfHBS1d0Ml6WU
         K5/fiDprqbnotHdK0rsU8Gb+3Vl7Mz8C0krvlL4Ho9I3ktE1WwCw75QLUof3DXbClB
         KZXQ7DGc/wOxKQ62l7DYgJrhRS9BOWyBN5AG8Xic+kGTxp4DZvSYeHVsLZxKc+yfw3
         AoiTmL0CKD69g==
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


On 9/15/20 11:10 PM, Christoph Hellwig wrote:
> On Mon, Sep 14, 2020 at 04:10:38PM -0700, Dan Williams wrote:
>> You also need to fix up ext4_break_layouts() and
>> xfs_break_dax_layouts() to expect ->_refcount is 0 instead of 1. This
>> also needs some fstests exposure.
> 
> While we're at it, can we add a wait_fsdax_unref helper macro that hides
> the _refcount access from the file systems?

Sure. I'll add a separate patch for it in v2.
