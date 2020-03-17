Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33AAD189192
	for <lists+kvm-ppc@lfdr.de>; Tue, 17 Mar 2020 23:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgCQWqZ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 17 Mar 2020 18:46:25 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4583 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbgCQWqZ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 17 Mar 2020 18:46:25 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e7152df0001>; Tue, 17 Mar 2020 15:44:48 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 17 Mar 2020 15:46:24 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 17 Mar 2020 15:46:24 -0700
Received: from rcampbell-dev.nvidia.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 17 Mar
 2020 22:46:23 +0000
Subject: Re: [PATCH 2/2] mm: remove device private page support from
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
References: <20200316175259.908713-1-hch@lst.de>
 <20200316175259.908713-3-hch@lst.de>
 <c099cc3c-c19f-9d61-4297-2e83df899ca4@nvidia.com>
 <20200316184935.GA25322@lst.de> <20200316200929.GB20010@ziepe.ca>
 <6de7ee97-45c7-b814-4dab-64e311dd86ce@nvidia.com>
 <20200317115649.GP20941@ziepe.ca>
X-Nvconfidentiality: public
From:   Ralph Campbell <rcampbell@nvidia.com>
Message-ID: <97b2c709-5134-72e1-b9ae-8f3ac2577bb8@nvidia.com>
Date:   Tue, 17 Mar 2020 15:46:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200317115649.GP20941@ziepe.ca>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1584485088; bh=2UDX/rWPDrZkbyJNh3gE0GcsBDENwsWQVmevu1FKQ9s=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=pbJwMKmkL8LJ/7a9qQOKcb8lZ1XrmO8Yz5cHySEzVO95sDAkZgS6DDQ8Nl7xuLTIS
         GIEJaby21lPv8/SiTJ6tGx6JS2Uco4vuKkMXnEyp9XG6tP7K3brob5lq7P8m/Ep20l
         kzit/oKwNKuIAULHpDiTpDE3ueaK9sA8fh7YimPu69ql56H75LqZl7n8oykTTFKgvh
         XNhsM05fPynABeTGfxnAjLw+6aK4ipjXmG4SWBtY/04CoYth/OOQwiyzwrM2Jr1Ylr
         mDFwNml1zNsS+J0vkvYFixBnSg9IDlIx/N9IJ+GRAEsbr5xqZAlHwyioOT0KNVuwqb
         4OrM68mOroWEQ==
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


On 3/17/20 4:56 AM, Jason Gunthorpe wrote:
> On Mon, Mar 16, 2020 at 01:24:09PM -0700, Ralph Campbell wrote:
> 
>> The reason for it being backwards is that "normally" a device doesn't want
>> the device private page to be faulted back to system memory, it wants to
>> get the device private struct page so it can update its page table to point
>> to the memory already in the device.
> 
> The "backwards" is you set the flag on input and never get it on
> output, clear the flag in input and maybe get it on output.
> 
> Compare with valid or write which don't work that way.
> 
>> Also, a device like Nvidia's GPUs may have an alternate path for copying
>> one GPU's memory to another (nvlink) without going through system memory
>> so getting a device private struct page/PFN from hmm_range_fault() that isn't
>> "owned" by the faulting GPU is useful.
>> I agree that the current code isn't well tested or thought out for multiple devices
>> (rdma, NVMe drives, GPUs, etc.) but it also ties in with peer-to-peer access via PCIe.
> 
> I think the series here is a big improvement. The GPU driver can set
> owners that match the hidden cluster interconnect.
> 
> Jason
> 

I agree this is an improvement. I was just thinking about possible future use cases.
