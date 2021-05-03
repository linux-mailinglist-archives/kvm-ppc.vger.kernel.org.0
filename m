Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2053B371FA1
	for <lists+kvm-ppc@lfdr.de>; Mon,  3 May 2021 20:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbhECS2c (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 3 May 2021 14:28:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24978 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229604AbhECS2c (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 3 May 2021 14:28:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620066458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1E+BaIjDxhZl6GZ7y81/Hi7Q9ChK6qWJNShgYtoeN+8=;
        b=TsXL/87rUTLipbq5dCEGPJtVg7cpMHXWvKY5QQCGiUTduSBI7jRhH9FEdm7mmzf41baFRU
        tzlOrPBl/s9Q1iTJ82XqWtFhWQRBMPpKgAf7wy+VGXZp6nAOFShEJkxRnekRSNQm3Gbz69
        r0/VW9haHFC0OXG7Lt461iWRL54sDy4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-1VUIJ22kPluutAz6Czm1Rw-1; Mon, 03 May 2021 14:27:35 -0400
X-MC-Unique: 1VUIJ22kPluutAz6Czm1Rw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA43318B9F41;
        Mon,  3 May 2021 18:27:32 +0000 (UTC)
Received: from [10.3.114.144] (ovpn-114-144.phx2.redhat.com [10.3.114.144])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 608806061F;
        Mon,  3 May 2021 18:27:23 +0000 (UTC)
Subject: Re: [PATCH v4 3/3] nvdimm: Enable sync-dax device property for nvdimm
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
 <161966813983.652.5749368609701495826.stgit@17be908f7c1c>
From:   Eric Blake <eblake@redhat.com>
Organization: Red Hat, Inc.
Message-ID: <f035a4ce-c070-6bb9-5792-da0a2d9d0a99@redhat.com>
Date:   Mon, 3 May 2021 13:27:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <161966813983.652.5749368609701495826.stgit@17be908f7c1c>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 4/28/21 10:49 PM, Shivaprasad G Bhat wrote:
> The patch adds the 'sync-dax' property to the nvdimm device.
> 
> When the sync-dax is 'direct' indicates the backend is synchronous DAX
> capable and no explicit flush requests are required. When the mode is
> set to 'writeback' it indicates the backend is not synhronous DAX

synchronous

> capable and explicit flushes to Hypervisor are required.
> 
> On PPC where the flush requests from guest can be honoured by the qemu,

s/the qemu/qemu/

> the 'writeback' mode is supported and set as the default. The device
> tree property "hcall-flush-required" is added to the nvdimm node which
> makes the guest to issue H_SCM_FLUSH hcalls to request for flushes

s/to issue/issue/
s/request for/request/

> explicitly. This would be the default behaviour without sync-dax
> property set for the nvdimm device. For old pSeries machine, the
> default is 'unsafe'.
> 
> For non-PPC platforms, the mode is set to 'unsafe' as the default.
> 
> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
> ---

> +++ b/qapi/common.json
> @@ -197,3 +197,23 @@
>  { 'enum': 'GrabToggleKeys',
>    'data': [ 'ctrl-ctrl', 'alt-alt', 'shift-shift','meta-meta', 'scrolllock',
>              'ctrl-scrolllock' ] }
> +
> +##
> +# @NvdimmSyncModes:
> +#
> +# Indicates the mode of flush to be used to ensure persistence in case
> +# of power failures.
> +#
> +# @unsafe: This is to indicate, the data on the backend device not be
> +#          consistent in power failure scenarios.

s/This is to indicate, the/This indicates that/
s/device not/device might not/

> +# @direct: This is to indicate the backend device supports synchronous DAX
> +#          and no explicit flush requests from the guest is required.

This indicates the backend device supports synchronous DAX, and no
explicit flush requests from the guest are required.

> +# @writeback: To be used when the backend device doesn't support synchronous
> +#             DAX. The hypervisor issues flushes to the disk when requested
> +#             by the guest.
> +# Since: 6.0

6.1

> +#
> +##
> +{ 'enum': 'NvdimmSyncModes',
> +  'data': [ 'unsafe', 'writeback',
> +            { 'name': 'direct', 'if': 'defined(CONFIG_LIBPMEM)' } ] }
> 
> 

-- 
Eric Blake, Principal Software Engineer
Red Hat, Inc.           +1-919-301-3226
Virtualization:  qemu.org | libvirt.org

