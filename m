Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA1F716661C
	for <lists+kvm-ppc@lfdr.de>; Thu, 20 Feb 2020 19:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbgBTSTw (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 20 Feb 2020 13:19:52 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33498 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727553AbgBTSTw (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 20 Feb 2020 13:19:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582222790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=obxVXBYRAmnOA1SZMlmZvsbkXpHvqTIQ+TOcUb8T0eE=;
        b=f8omgFQB9GzQzdxcDTW8LnHGq6Ld/yx7A63SUasM1KNAZgQ6U458fuIObp4DItlgVHIg5q
        KG/V/LdVA5vZWWdfp6TVVqR+jUoHFa6YZjvsbkARKwyXNKznd4iZXOSQSpz0/lsUR0ZIQu
        ZgYJPepu1UHiLSfxI3P34896BmPMCTs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-otoHWshVPT-jZMjRZUw8mQ-1; Thu, 20 Feb 2020 13:19:46 -0500
X-MC-Unique: otoHWshVPT-jZMjRZUw8mQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F5E51005510;
        Thu, 20 Feb 2020 18:19:44 +0000 (UTC)
Received: from w520.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 43BA386E0D;
        Thu, 20 Feb 2020 18:19:43 +0000 (UTC)
Date:   Thu, 20 Feb 2020 11:19:42 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, Alistair Popple <alistair@popple.id.au>
Subject: Re: [PATCH kernel 5/5] vfio/spapr_tce: Advertise and allow a huge
 DMA windows at 4GB
Message-ID: <20200220111942.2b53414a@w520.home>
In-Reply-To: <20200218073650.16149-6-aik@ozlabs.ru>
References: <20200218073650.16149-1-aik@ozlabs.ru>
        <20200218073650.16149-6-aik@ozlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, 18 Feb 2020 18:36:50 +1100
Alexey Kardashevskiy <aik@ozlabs.ru> wrote:

> So far the only option for a big 64big DMA window was a window located
> at 0x800.0000.0000.0000 (1<<59) which creates problems for devices
> supporting smaller DMA masks.
> 
> This exploits a POWER9 PHB option to allow the second DMA window to map
> at 0 and advertises it with a 4GB offset to avoid overlap with
> the default 32bit window.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
>  include/uapi/linux/vfio.h           |  2 ++
>  drivers/vfio/vfio_iommu_spapr_tce.c | 10 ++++++++--
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 9e843a147ead..c7f89d47335a 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -831,9 +831,11 @@ struct vfio_iommu_spapr_tce_info {
>  	__u32 argsz;
>  	__u32 flags;
>  #define VFIO_IOMMU_SPAPR_INFO_DDW	(1 << 0)	/* DDW supported */
> +#define VFIO_IOMMU_SPAPR_INFO_DDW_START	(1 << 1)	/* DDW offset */
>  	__u32 dma32_window_start;	/* 32 bit window start (bytes) */
>  	__u32 dma32_window_size;	/* 32 bit window size (bytes) */
>  	struct vfio_iommu_spapr_tce_ddw_info ddw;
> +	__u64 dma64_window_start;
>  };
>  
>  #define VFIO_IOMMU_SPAPR_TCE_GET_INFO	_IO(VFIO_TYPE, VFIO_BASE + 12)
> diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
> index 16b3adc508db..4f22be3c4aa2 100644
> --- a/drivers/vfio/vfio_iommu_spapr_tce.c
> +++ b/drivers/vfio/vfio_iommu_spapr_tce.c
> @@ -691,7 +691,7 @@ static long tce_iommu_create_window(struct tce_container *container,
>  	container->tables[num] = tbl;
>  
>  	/* Return start address assigned by platform in create_table() */
> -	*start_addr = tbl->it_offset << tbl->it_page_shift;
> +	*start_addr = tbl->it_dmaoff << tbl->it_page_shift;
>  
>  	return 0;
>  
> @@ -842,7 +842,13 @@ static long tce_iommu_ioctl(void *iommu_data,
>  			info.ddw.levels = table_group->max_levels;
>  		}
>  
> -		ddwsz = offsetofend(struct vfio_iommu_spapr_tce_info, ddw);
> +		ddwsz = offsetofend(struct vfio_iommu_spapr_tce_info,
> +				dma64_window_start);

This breaks existing users, now they no longer get the ddw struct
unless their argsz also includes the new dma64 window field.

> +
> +		if (info.argsz >= ddwsz) {
> +			info.flags |= VFIO_IOMMU_SPAPR_INFO_DDW_START;
> +			info.dma64_window_start = table_group->tce64_start;
> +		}

This is inconsistent with ddw where we set the flag regardless of
argsz, but obviously only provide the field to the user if they've
provided room for it.  Thanks,

Alex

>  
>  		if (info.argsz >= ddwsz)
>  			minsz = ddwsz;

