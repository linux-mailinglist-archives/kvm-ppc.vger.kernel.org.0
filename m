Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B448057EA0E
	for <lists+kvm-ppc@lfdr.de>; Sat, 23 Jul 2022 00:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235204AbiGVWui (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 22 Jul 2022 18:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbiGVWuh (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 22 Jul 2022 18:50:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D09F622B17
        for <kvm-ppc@vger.kernel.org>; Fri, 22 Jul 2022 15:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658530235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5G+9XofFYtjcjc9nMklfj+U+SYfTvHOn025PmT4w4OA=;
        b=gIC0KkPnEczr7Ug7ADupegVWAGTB2FklPDAq3hxZ/LmmuOp10qxOpWYsFBWibdQ7IsitxY
        Gpuedcw8vUEBdZagNpEHjjsq5RoKaqX+Fwwf2iUCi1AjbtfxCrdZP8NJxkMRYnEP71wF0m
        1UxqmcF7Bog0SVU/qvKHYavAMjzoxno=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-338-jSItglruNK2dRPScg5BIwQ-1; Fri, 22 Jul 2022 18:50:34 -0400
X-MC-Unique: jSItglruNK2dRPScg5BIwQ-1
Received: by mail-il1-f199.google.com with SMTP id g8-20020a92cda8000000b002dcbd57f808so3458183ild.4
        for <kvm-ppc@vger.kernel.org>; Fri, 22 Jul 2022 15:50:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=5G+9XofFYtjcjc9nMklfj+U+SYfTvHOn025PmT4w4OA=;
        b=Uuf+ljeA9ozJ9mY4wnUPiCraGNiniaGtDh49W8M3vtEo1nf8Pf2T6a/BOPOLeI+rba
         kKzS1F19yFQx9qjOsh1L4KRFdsa6HgPWfwvr3smhRqWhDb3dEituxKQYvzMna8GCkGNY
         La4scQ4y5fai1y4xrDxK+SRWTPTPjHmksDdIZyuDwqrQoSacljYZpIVkX+AXiNrWQXD1
         LVYfKFfxNpBrAHakvlD0UmaTKk5n1Inj/3IBJJE3P0LfTPdKjCGyyd+sh++IQItakN3n
         5LlxnZDoxspF3yAgYJrnHWbfPL2jEMw+GJnbQTcWb6a9s7dnfcKz4J9pdvBOHI+Ewk5d
         MZ+A==
X-Gm-Message-State: AJIora8lVAtM2YfpGLhfoNaH5y8L2UM8YXpazdZapUoCw9AB/01CC0Tk
        +q/tKKGNqr52Q/8hWQMFvqDm87I5x86eLqVYJSNSvxqCBVIP0I5TsSIZxrA3ybmW9Ai7uCJ/FS+
        HUJkaW+CRqlhEdBA5LQ==
X-Received: by 2002:a6b:146:0:b0:67b:c614:d6bd with SMTP id 67-20020a6b0146000000b0067bc614d6bdmr676747iob.76.1658530233793;
        Fri, 22 Jul 2022 15:50:33 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sHnPDxfnE1FYRt+HswBN5/Vx6Bm07TqPL4q4XagHh2Kh1ra94En6q+UnhzhVSmG3FYDySiCg==
X-Received: by 2002:a6b:146:0:b0:67b:c614:d6bd with SMTP id 67-20020a6b0146000000b0067bc614d6bdmr676743iob.76.1658530233576;
        Fri, 22 Jul 2022 15:50:33 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id f16-20020a022410000000b0033e72ec9d93sm2527322jaa.145.2022.07.22.15.50.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 15:50:32 -0700 (PDT)
Date:   Fri, 22 Jul 2022 16:50:27 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH kernel] vfio/spapr_tce: Fix the comment
Message-ID: <20220722165027.13dc2045.alex.williamson@redhat.com>
In-Reply-To: <20220714080912.3713509-1-aik@ozlabs.ru>
References: <20220714080912.3713509-1-aik@ozlabs.ru>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, 14 Jul 2022 18:09:12 +1000
Alexey Kardashevskiy <aik@ozlabs.ru> wrote:

> Grepping for "iommu_ops" finds this spot and gives wrong impression
> that iommu_ops is used in here, fix the comment.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
>  drivers/vfio/vfio_iommu_spapr_tce.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
> index 708a95e61831..cd7b9c136889 100644
> --- a/drivers/vfio/vfio_iommu_spapr_tce.c
> +++ b/drivers/vfio/vfio_iommu_spapr_tce.c
> @@ -1266,7 +1266,7 @@ static int tce_iommu_attach_group(void *iommu_data,
>  		goto unlock_exit;
>  	}
>  
> -	/* Check if new group has the same iommu_ops (i.e. compatible) */
> +	/* Check if new group has the same iommu_table_group_ops (i.e. compatible) */
>  	list_for_each_entry(tcegrp, &container->group_list, next) {
>  		struct iommu_table_group *table_group_tmp;
>  

Applied to vfio next branch for v5.20 with a conversion to a multi-line
comment to avoid the long line.  Thanks,

Alex

