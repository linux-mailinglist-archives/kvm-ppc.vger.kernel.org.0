Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFB6E31838A
	for <lists+kvm-ppc@lfdr.de>; Thu, 11 Feb 2021 03:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbhBKC05 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 10 Feb 2021 21:26:57 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:2234 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbhBKC04 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 10 Feb 2021 21:26:56 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602495c80000>; Wed, 10 Feb 2021 18:26:16 -0800
Received: from [10.2.50.67] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 11 Feb
 2021 02:26:16 +0000
Subject: Re: [PATCH 0/9] Add support for SVM atomics in Nouveau
To:     Alistair Popple <apopple@nvidia.com>,
        Linux MM <linux-mm@kvack.org>,
        Nouveau Dev <nouveau@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <kvm-ppc@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Jerome Glisse <jglisse@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
References: <20210209010722.13839-1-apopple@nvidia.com>
 <CAKMK7uGwg2-DTU7Zrco=TSkcR4yTqN1AF0hvVYEAbuj4BUYi5Q@mail.gmail.com>
 <3426910.QXTomnrpqD@nvdebian>
 <CAKMK7uHp+BzHF1=JhKjv5HYm_j0SVqsGdRqjUxVFYx4GSEPucg@mail.gmail.com>
 <57fe0deb-8bf6-d3ee-3545-11109e946528@nvidia.com>
 <YCPYtNeYCuu6i2/d@phenom.ffwll.local>
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <2906f445-babb-5f4e-2d99-dc004ae1face@nvidia.com>
Date:   Wed, 10 Feb 2021 18:26:15 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:85.0) Gecko/20100101
 Thunderbird/85.0
MIME-Version: 1.0
In-Reply-To: <YCPYtNeYCuu6i2/d@phenom.ffwll.local>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613010376; bh=fWiSyOBWsVzyVm55YFwZ6S/xqnjzAJ77D4BJX4IdmYQ=;
        h=Subject:To:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=leaB4fiXqE16gCtniTXQN7wSpNK6vqgNBnsubO6Sqz20znNTYyS1DivzYTMRS4UV7
         w5Vir0tdNZkJIZJNa7GWAZkmqVslmOQbbFoYCui9m3qncJPbiLoeAgW6aOlHumrkeb
         AvqNZnglqc7Brug+AtJ88e4mmqyLBYYytyn9i/agt07SeilKDzj3ypZZzMaPyEc/1f
         qfcVy3BbtVAyuYqrqLZA+t6jewjnFT5OuJgR0tr56q4bF5w7n5XURdxoT6MgKpdprH
         LtGPzO04XwunHPGKsOBJRZoELR3w5OcRZukw35gXqIHSILXS8DAoXlexMKrAUC4a98
         gWaYeMFi1C9IA==
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 2/10/21 4:59 AM, Daniel Vetter wrote:
...
>> GPU atomic operations to sysmem are hard to categorize, because because application
>> programmers could easily write programs that do a long series of atomic operations.
>> Such a program would be a little weird, but it's hard to rule out.
> 
> Yeah, but we can forcefully break this whenever we feel like by revoking
> the page, moving it, and then reinstating the gpu pte again and let it
> continue.

Oh yes, that's true.

> 
> If that's no possible then what we need here instead is an mlock() type of
> thing I think.
No need for that, then.


thanks,
-- 
John Hubbard
NVIDIA
