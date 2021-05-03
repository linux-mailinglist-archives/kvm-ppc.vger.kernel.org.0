Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8ECD371F94
	for <lists+kvm-ppc@lfdr.de>; Mon,  3 May 2021 20:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbhECSY5 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 3 May 2021 14:24:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24825 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229594AbhECSY4 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 3 May 2021 14:24:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620066242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bOndVeIoEuD6BxxxnUoCWdomohKYh7q5QO21fTfb7Rs=;
        b=SkxtrOpRn/qsS5zvUShMC/hwS1sQngTFX1MmY//mkpl6RY1YDWLeb7rKELa0bsR9FyoE+x
        miVN2kTsFbtFnca9HzV0iXew1yM+VzccEesivy1e8y+ke7oxAUnspc1URWqdNvw8r/hk01
        THg9hLQB40BC15duFWm1vvOmMy/TKh0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-wJoHu14tMkqq6VCExnMgoQ-1; Mon, 03 May 2021 14:24:01 -0400
X-MC-Unique: wJoHu14tMkqq6VCExnMgoQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45556100A608;
        Mon,  3 May 2021 18:23:58 +0000 (UTC)
Received: from [10.3.114.144] (ovpn-114-144.phx2.redhat.com [10.3.114.144])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8979B6061F;
        Mon,  3 May 2021 18:23:47 +0000 (UTC)
Subject: Re: [PATCH v4 1/3] spapr: nvdimm: Forward declare and move the
 definitions
To:     Shivaprasad G Bhat <sbhat@linux.ibm.com>,
        david@gibson.dropbear.id.au, groug@kaod.org, qemu-ppc@nongnu.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        imammedo@redhat.com, xiaoguangrong.eric@gmail.com,
        peter.maydell@linaro.org, qemu-arm@nongnu.org,
        richard.henderson@linaro.org, pbonzini@redhat.com,
        stefanha@redhat.com, haozhong.zhang@intel.com,
        shameerali.kolothum.thodi@huawei.com, kwangwoo.lee@sk.com,
        armbru@redhat.com
Cc:     qemu-devel@nongnu.org, aneesh.kumar@linux.ibm.com,
        linux-nvdimm@lists.01.org, kvm-ppc@vger.kernel.org,
        shivaprasadbhat@gmail.com, bharata@linux.vnet.ibm.com
References: <161966810162.652.13723419108625443430.stgit@17be908f7c1c>
 <161966811094.652.571342595267518155.stgit@17be908f7c1c>
From:   Eric Blake <eblake@redhat.com>
Organization: Red Hat, Inc.
Message-ID: <f33dfff6-a1f7-244f-531e-ef0d93ad0c3d@redhat.com>
Date:   Mon, 3 May 2021 13:23:47 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <161966811094.652.571342595267518155.stgit@17be908f7c1c>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 4/28/21 10:48 PM, Shivaprasad G Bhat wrote:
> The subsequent patches add definitions which tend to
> get the compilation to cyclic dependency. So, prepare
> with forward declarations, move the defitions and clean up.

definitions

> 
> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
> ---
>  hw/ppc/spapr_nvdimm.c         |   12 ++++++++++++
>  include/hw/ppc/spapr_nvdimm.h |   14 ++------------
>  2 files changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/hw/ppc/spapr_nvdimm.c b/hw/ppc/spapr_nvdimm.c
> index b46c36917c..8cf3fb2ffb 100644
> --- a/hw/ppc/spapr_nvdimm.c
> +++ b/hw/ppc/spapr_nvdimm.c
> @@ -31,6 +31,18 @@
>  #include "qemu/range.h"
>  #include "hw/ppc/spapr_numa.h"
>  
> +/*
> + * The nvdimm size should be aligned to SCM block size.
> + * The SCM block size should be aligned to SPAPR_MEMORY_BLOCK_SIZE
> + * inorder to have SCM regions not to overlap with dimm memory regions.

And while at it, even though it is code motion...

> + * The SCM devices can have variable block sizes. For now, fixing the
> + * block size to the minimum value.
> + */
> +#define SPAPR_MINIMUM_SCM_BLOCK_SIZE SPAPR_MEMORY_BLOCK_SIZE

> +++ b/include/hw/ppc/spapr_nvdimm.h
> @@ -11,19 +11,9 @@
>  #define HW_SPAPR_NVDIMM_H
>  
>  #include "hw/mem/nvdimm.h"
> -#include "hw/ppc/spapr.h"
>  
> -/*
> - * The nvdimm size should be aligned to SCM block size.
> - * The SCM block size should be aligned to SPAPR_MEMORY_BLOCK_SIZE
> - * inorder to have SCM regions not to overlap with dimm memory regions.

... this should be "in order"

-- 
Eric Blake, Principal Software Engineer
Red Hat, Inc.           +1-919-301-3226
Virtualization:  qemu.org | libvirt.org

