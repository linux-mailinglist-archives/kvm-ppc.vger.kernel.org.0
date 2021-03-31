Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6952934F7B7
	for <lists+kvm-ppc@lfdr.de>; Wed, 31 Mar 2021 06:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbhCaEKa (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 31 Mar 2021 00:10:30 -0400
Received: from mail-dm6nam12on2043.outbound.protection.outlook.com ([40.107.243.43]:34816
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229615AbhCaEJ7 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 31 Mar 2021 00:09:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KG3sleijmfshsnVgiuXnc0VXH+VAbYcZHgXDbDM9tW7xola5sK1/L/ODJpXk1GYM5ozAciD2rtiAyok8lXvBPbLpukp8ygkH2WXYg6J1QNLH8tfU7wC6XOjuL7/Su2moNPHMC1WlOSoVma/pRCgtzW4FSpDXu4lgyjjd9bvF+6+tKOHJoDLH6MmyBiuCiqwBNBJ0FJ0Bh/t4v1w+eWGWymBcrvskQpDw67TG8MNg3kssGzeEznWYnkewV5+T6J6/WaessxFAWH2gcDw8+xfcQ7gQdXszOnpyxvBQXNQEfg3KNQe89wh4zxiyBIgM851rWUiG0XE2pTiwVSMxz+5Azw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SXXGpRObgcKxUvREhZ5EfSSsMUPiAAFeZVNFXO5ZyL8=;
 b=f4Y6mJUvTBn4ygmtTZPgriGsoG6dTjYifA46Q7eqN8t+QiguJbRL3p4aUqvhKf5K1dYM2VkZYBec+MSbDNeCDo4BjRTu3afuIAm/Q6wfhpjTJXFDsWI/4ZklBptTa6K/1idfk9JNDxZlcPpBjYJlhSZz3OWsoGnkZWuEDkw/2+zsWpZlDrfXaVt6ec30OgztjVcF0T/8EMDgh+0di+BEF7mTFyY8DA7t3yREQVbjSDIfNNwzVgkgtojFtykdx2DaQ6aBvX1+5Rahm8HCJAQ+jCS9A+GaqyI9kWa+wt5SYbXY6Ddeab9s7Rx0HK+W0onKDHXe0S+mYZXDPt/I5JcL8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SXXGpRObgcKxUvREhZ5EfSSsMUPiAAFeZVNFXO5ZyL8=;
 b=J0AN9lO0lDBkLZW577JcdQxHfE7SxMaWAb1gNCA/mV7/Ev6ssBQP/BNWSIxoBjfBVurFwBmoSTttYA5nfWh/GKXNLzC1N4ooyuQ6Os+8BXVr5mLiWd2AIBFH14zABSW1YjgS0Dh1o+0zDcHp6pnO3MIdLmpBY0deQD9dzYZoOq6oe9W8QuUnlKYdaEiTJoyzZcrBPYbgfvoFmjWWNtVq7POpK1JL23Kq8deZG+TY2cBPj2a/k491uDIaX6op3u8mb45Rbod2cuRI9vIhSdbfvhIXyQcCwWi/BmfaDCYn4Dz4dS2qjxW9fN3uJFUlY+h+DSV9DAF5c1CdNg+YdJd//A==
Received: from BN6PR16CA0020.namprd16.prod.outlook.com (2603:10b6:404:f5::30)
 by CH2PR12MB4247.namprd12.prod.outlook.com (2603:10b6:610:7c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Wed, 31 Mar
 2021 04:09:58 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:f5:cafe::ed) by BN6PR16CA0020.outlook.office365.com
 (2603:10b6:404:f5::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend
 Transport; Wed, 31 Mar 2021 04:09:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; linux-foundation.org; dkim=none (message not
 signed) header.d=none;linux-foundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Wed, 31 Mar 2021 04:09:57 +0000
Received: from [10.2.63.109] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 31 Mar
 2021 04:09:56 +0000
Subject: Re: [PATCH v7 3/8] mm/rmap: Split try_to_munlock from try_to_unmap
From:   John Hubbard <jhubbard@nvidia.com>
To:     Alistair Popple <apopple@nvidia.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>, <linux-mm@kvack.org>,
        <nouveau@lists.freedesktop.org>, <bskeggs@redhat.com>,
        <akpm@linux-foundation.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kvm-ppc@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <rcampbell@nvidia.com>,
        <jglisse@redhat.com>, <hch@infradead.org>, <daniel@ffwll.ch>,
        <willy@infradead.org>, Christoph Hellwig <hch@lst.de>
References: <20210326000805.2518-1-apopple@nvidia.com>
 <20210330222440.GC2356281@nvidia.com>
 <bce0605a-336f-99ba-5b65-a8e5a7e49e00@nvidia.com>
 <12636584.zsJ0Sx4KLp@nvdebian>
 <b4b11c59-975d-26c7-043a-6acddff78dfd@nvidia.com>
Message-ID: <5f156670-e8d0-e62a-2286-764687a6669f@nvidia.com>
Date:   Tue, 30 Mar 2021 21:09:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <b4b11c59-975d-26c7-043a-6acddff78dfd@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1e0ab9e-2a38-4cd6-d901-08d8f3fad8c5
X-MS-TrafficTypeDiagnostic: CH2PR12MB4247:
X-Microsoft-Antispam-PRVS: <CH2PR12MB424725FB554880BBFE09BBA2A87C9@CH2PR12MB4247.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IXnxcDCMG7HgK1yl5/JC1fcnLUDMGnnv12SjLkhjBFbbMBCXwrZqjcVa79tPiKuGLfUjySW+2bynrlZsmzxpsDkkZDT4Qnvy8tpyfoDubHH2fWppXyp0CAVZTDg2HR4q7jpWL+DPp/qyIKh3zr0GZJvlVktZ8BA5H+QVXJ2q7xgnwV898rZnpYhb92b8w9kuzABplcvb9U5S+/IKUass1bTTzODr9T3ZUB7Ivnjtp9BLMJcQYKHEv5Wj/rPud9rbivrmiibjzj/JmHK7NSa6sKhEGj8YPigBl6fNeoFJ6Pdm2ZC/eKt7yhCQxDGtgxytTWrf89gJbWG+C1AYDOoY2leCKXj47uogFUM83yggg46EpXQiF+I0VN0C/zgjAmyunw3p7SdRaMkpX9b0u5wwStxzcheq4FZHz83RW/3KSbA9AvjeQzl4+S4ejfVhRA+KPuJAEFnxITzZ8t8JpXBSrkj9Nxo/wwZog9mF88+WxkBU7hrMQGTuU1y/nfKCQymcxx/satX5f/ylYVGVJNmJeB/lz4MmnKtjBTp7E3tMOsPmHfRtXPIxYveSRteMO02Ov4VcLnwFzhL55OIMM5Z2oMglg3KlfAsuukiAP84kbEineqOMPyvKWnhcqoRN8gQSV4zY+EMSrwGdzxa5PKOvjzAERhqzALNJkCp7VJ3zalYRxvxWkp0cjMbXMqjkYy1o
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39860400002)(346002)(46966006)(36840700001)(36906005)(70586007)(83380400001)(31696002)(7416002)(4326008)(70206006)(316002)(26005)(37006003)(16526019)(31686004)(186003)(82310400003)(336012)(7636003)(36860700001)(47076005)(8936002)(2616005)(8676002)(356005)(82740400003)(478600001)(5660300002)(2906002)(6636002)(6862004)(54906003)(86362001)(36756003)(16576012)(53546011)(426003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2021 04:09:57.5524
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1e0ab9e-2a38-4cd6-d901-08d8f3fad8c5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4247
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 3/30/21 8:56 PM, John Hubbard wrote:
> On 3/30/21 3:56 PM, Alistair Popple wrote:
> ...
>>> +1 for renaming "munlock*" items to "mlock*", where applicable. good grief.
>>
>> At least the situation was weird enough to prompt further investigation :)
>>
>> Renaming to mlock* doesn't feel like the right solution to me either though. I
>> am not sure if you saw me responding to myself earlier but I am thinking
>> renaming try_to_munlock() -> page_mlocked() and try_to_munlock_one() ->
>> page_mlock_one() might be better. Thoughts?
>>
> 
> Quite confused by this naming idea. Because: try_to_munlock() returns
> void, so a boolean-style name such as "page_mlocked()" is already not a
> good fit.
> 
> Even more important, though, is that try_to_munlock() is mlock-ing the
> page, right? Is there some subtle point I'm missing? It really is doing
> an mlock to the best of my knowledge here. Although the kerneldoc
> comment for try_to_munlock() seems questionable too:
> 
> /**
> * try_to_munlock - try to munlock a page
> * @page: the page to be munlocked
> *
> * Called from munlock code.  Checks all of the VMAs mapping the page
> * to make sure nobody else has this page mlocked. The page will be
> * returned with PG_mlocked cleared if no other vmas have it mlocked.
> */
> 
> ...because I don't see where, in *this* routine, it clears PG_mlocked!
> 
> Obviously we agree that a routine should be named based on what it does,
> rather than on who calls it. So I think that still leads to:
> 
>      try_to_munlock() --> try_to_mlock()
>      try_to_munlock_one() --> try_to_mlock_one()
> 
> Sorry if I'm missing something really obvious.

Actually, re-reading your and Jason's earlier points in the thread, I see
that I'm *not* missing anything, and we are actually in agreement about how
the code operates. OK, good!

Also, as you point out above, maybe the "try_" prefix is not really accurate
either, given how this works. So maybe we have arrived at something like:

     try_to_munlock() --> page_mlock() // or mlock_page()...
     try_to_munlock_one() --> page_mlock_one()



thanks,
-- 
John Hubbard
NVIDIA
