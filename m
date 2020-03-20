Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54F1718C4A2
	for <lists+kvm-ppc@lfdr.de>; Fri, 20 Mar 2020 02:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgCTBdJ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 19 Mar 2020 21:33:09 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:13787 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727049AbgCTBdI (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 19 Mar 2020 21:33:08 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e741cf10000>; Thu, 19 Mar 2020 18:31:29 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 19 Mar 2020 18:33:07 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 19 Mar 2020 18:33:07 -0700
Received: from rcampbell-dev.nvidia.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Mar
 2020 01:33:07 +0000
Subject: Re: [PATCH 3/4] mm: simplify device private page handling in
 hmm_range_fault
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Jerome Glisse <jglisse@redhat.com>, <kvm-ppc@vger.kernel.org>,
        <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <nouveau@lists.freedesktop.org>, <linux-mm@kvack.org>
References: <20200316193216.920734-1-hch@lst.de>
 <20200316193216.920734-4-hch@lst.de>
 <7256f88d-809e-4aba-3c46-a223bd8cc521@nvidia.com>
 <20200317121536.GQ20941@ziepe.ca> <20200317122445.GA11662@lst.de>
 <20200317122813.GA11866@lst.de> <20200317124755.GR20941@ziepe.ca>
 <20200317125955.GA12847@lst.de>
 <24fca825-3b0f-188f-bcf2-fadcf3a9f05a@nvidia.com>
 <20200320001428.GA9199@ziepe.ca>
X-Nvconfidentiality: public
From:   Ralph Campbell <rcampbell@nvidia.com>
Message-ID: <8d549ef6-14ae-7055-58c8-d56de8bf4ba6@nvidia.com>
Date:   Thu, 19 Mar 2020 18:33:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200320001428.GA9199@ziepe.ca>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1584667889; bh=0XrmkYqlA+KPtFLXc9j6McuShC8myf+16OYVMSLPN98=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=q8yRQ8OgBCDzsDjIi7BZWgW2W6wpR+FQ9bo0pOdEKoDHdimpX9OlV1kxhTKGxCsdK
         y7oGNmhxCYODXGZbFeJdZEagt9ppPLakBoNElC0LiRiYd/f4G5cClYDE/oM846Gca1
         m+mW8C4/i21sEKSuLvhfqFle1bJELFzb9iAxvgXvYXuG3ISf6g1cRwlGQeREzIY+MB
         VkbG0wNleCaEdDy/5biJSdif8WCwBTrVsrsENIUiCRuDE8RrpgajhsBXiSiJfJ7RGp
         ropfu4FvhZlxXPEZ7zcifJz6ZW7mhcjktbl6+ToyvLn0TCLionmVu5NS2mntJg0+e0
         M+COmpAgYcPfA==
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


On 3/19/20 5:14 PM, Jason Gunthorpe wrote:
> On Tue, Mar 17, 2020 at 04:14:31PM -0700, Ralph Campbell wrote:
> 
>> +static int dmirror_fault(struct dmirror *dmirror, unsigned long start,
>> +			 unsigned long end, bool write)
>> +{
>> +	struct mm_struct *mm = dmirror->mm;
>> +	unsigned long addr;
>> +	uint64_t pfns[64];
>> +	struct hmm_range range = {
>> +		.notifier = &dmirror->notifier,
>> +		.pfns = pfns,
>> +		.flags = dmirror_hmm_flags,
>> +		.values = dmirror_hmm_values,
>> +		.pfn_shift = DPT_SHIFT,
>> +		.pfn_flags_mask = ~(dmirror_hmm_flags[HMM_PFN_VALID] |
>> +				    dmirror_hmm_flags[HMM_PFN_WRITE]),
> 
> Since pfns is not initialized pfn_flags_mask should be 0.

Good point.

>> +		.default_flags = dmirror_hmm_flags[HMM_PFN_VALID] |
>> +				(write ? dmirror_hmm_flags[HMM_PFN_WRITE] : 0),
>> +		.dev_private_owner = dmirror->mdevice,
>> +	};
>> +	int ret = 0;
> 
>> +static int dmirror_snapshot(struct dmirror *dmirror,
>> +			    struct hmm_dmirror_cmd *cmd)
>> +{
>> +	struct mm_struct *mm = dmirror->mm;
>> +	unsigned long start, end;
>> +	unsigned long size = cmd->npages << PAGE_SHIFT;
>> +	unsigned long addr;
>> +	unsigned long next;
>> +	uint64_t pfns[64];
>> +	unsigned char perm[64];
>> +	char __user *uptr;
>> +	struct hmm_range range = {
>> +		.pfns = pfns,
>> +		.flags = dmirror_hmm_flags,
>> +		.values = dmirror_hmm_values,
>> +		.pfn_shift = DPT_SHIFT,
>> +		.pfn_flags_mask = ~0ULL,
> 
> Same here, especially since this is snapshot
> 
> Jason

Actually, snapshot ignores pfn_flags_mask and default_flags.
In hmm_pte_need_fault(), HMM_FAULT_SNAPSHOT is checked and returns early before
checking pfn_flags_mask and default_flags since no faults are being requested.

