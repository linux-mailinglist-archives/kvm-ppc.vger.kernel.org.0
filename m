Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A263152991D
	for <lists+kvm-ppc@lfdr.de>; Tue, 17 May 2022 07:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234068AbiEQFlR (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 17 May 2022 01:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238132AbiEQFk7 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 17 May 2022 01:40:59 -0400
X-Greylist: delayed 5527 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 16 May 2022 22:40:52 PDT
Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02hn2242.outbound.protection.partner.outlook.cn [139.219.146.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931A1AE40;
        Mon, 16 May 2022 22:40:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NribvH1vFEic4/W+tbJiwJZbi6QzdzKFEFXwU7ugkmoLZ50EGj12pJSh9D7WUWpX5qt7GrvYKoxrFSbKPZVqrgsGj9w4Ck2+NPHewRYao6BVGdAKGO2ctFrouXKRtQvvpguYUxRWmRKCE7S+wmmwzb3Jrnu4obWEfCLJIWvG6xWzA9oohvbBRWT2jzXXCA6meF3Wox3pngHRgi0IJoQQTStLqz1FzdrghuavlXBc0mj0y3efsqwxcONyCL0NcuFL3uE35IgkAP0V319+3yUUkD1oo1UZJSGznmDI/0keCNjLydnZfJJQfqL6dmOiRD5H8l+rSWeslBTjXcoY7Lmd7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O0bN2yFrDuIMFF+d7QRyaVBLs0/VHZTrkLthID1smys=;
 b=k1w2ni/JYRwX5Qk2iTAwUujFuBhWrYrGxLlpKqoe+4QHeEUhy5TvkdAxqImdz4p0KdQfajg8AfIvnyc36jHtzUQsPg7W1vBL41d+7/oEAIeHjZCeF06vnttFBKt6sa2xJNrAL3YEQWmocRh7/oBSXXEatngu/AQGZqCClcKo09SFNo4yDlWpImO9F41X41RwuTG0KPBiXLwz+1MydbcMp/o4eIWAyNpPZaraB4VG60C+WIZDT+8rEfhSgZfrU3lUvNWUw8oNERI2RlzFy/zpGy6JpsVMjDrnZA1LPfCpQtth8XYVvJKf/gFdcdajx5GKCOyvT7NhRnm10zSXL3Q5sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=gientech.com; dmarc=pass action=none header.from=gientech.com;
 dkim=pass header.d=gientech.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gientech.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O0bN2yFrDuIMFF+d7QRyaVBLs0/VHZTrkLthID1smys=;
 b=ZHKv09EWlzbX3dWJNsyOI21rdOGPXQPcN03K8FuzMpczNQm+5brFyhDe+3qbMxmD/Nm4R7j0JOfjgQoLPQ7oXC+csxOwikHS2SPOSLYiY/zW5dEoZMoMv5asZhi46DE3v+2pWArUjix3Y1GeVJiELr7x3MWY69pVDT2a9i0Dq5bXJ2WeIegSZ0NB3852xWkyhbdVOWv8+P/OoM+zcrrCZnUmqtcoK2qjv+DhqqD7SeuZMOoe7xUqStu3oIgtwCCjByJPshcvcc1zUL66eREyVmaetpz9M6Xlw2LwL7zNYoVKNFT2llFBzgW32flZd8uYmTecaEpKEd/whWUQ2ccBlg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=gientech.com;
Received: from BJXPR01MB198.CHNPR01.prod.partner.outlook.cn (10.41.52.24) by
 BJXPR01MB0535.CHNPR01.prod.partner.outlook.cn (10.43.32.82) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.14; Tue, 17 May 2022 04:08:41 +0000
Received: from BJXPR01MB198.CHNPR01.prod.partner.outlook.cn ([10.41.52.24]) by
 BJXPR01MB198.CHNPR01.prod.partner.outlook.cn ([10.41.52.24]) with mapi id
 15.20.5250.018; Tue, 17 May 2022 04:08:41 +0000
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Re;
To:     Recipients <youchun.wang@gientech.com>
From:   "J Wu" <youchun.wang@gientech.com>
Date:   Sat, 14 May 2022 04:31:28 +0000
Reply-To: contact@jimmywu.online
X-ClientProxiedBy: SH2PR01CA020.CHNPR01.prod.partner.outlook.cn (10.41.247.30)
 To BJXPR01MB198.CHNPR01.prod.partner.outlook.cn (10.41.52.24)
Message-ID: <BJXPR01MB19888670F4A672585880640E8CD9@BJXPR01MB198.CHNPR01.prod.partner.outlook.cn>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51b029b7-c1da-4fb6-7dae-08da3562ac86
X-MS-TrafficTypeDiagnostic: BJXPR01MB0535:EE_
X-Microsoft-Antispam-PRVS: <BJXPR01MB0535259F82F8758D54EC2D92E8CE9@BJXPR01MB0535.CHNPR01.prod.partner.outlook.cn>
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?lW39L/CDXWwHAywayJOm/wPEimC52gK2LOhUHKsshWjoqT1o+sQRfi4HSl?=
 =?iso-8859-1?Q?KNqqX88mFSsoN8nCwkbmqRhch0zgFvfYcSkJGJKFgPK7aoNDwl1Mi2aRQh?=
 =?iso-8859-1?Q?612ZBdrnzX9xsSwcjR0LbetTW7aaCg76r7UXJjO8/JMMpXFs/iYdSnM8M8?=
 =?iso-8859-1?Q?dZDDEgULc5oQABMuroFi3EXD/zwPyoGlgzbK/xdYp7t+mkLwpJMvcxq+81?=
 =?iso-8859-1?Q?Z+g+wrWz1uadjRm7izIP9Rm5KMvIHAh6M896bnd6grtRDJQ0P7vcFjnN0k?=
 =?iso-8859-1?Q?bL52XqPN0on3AHNQGJ+KFJFXbcu7HMXOgbieMVzQ8xBACe8YCLQRXkpjtu?=
 =?iso-8859-1?Q?QBH3/rkhm/c9riGh+U5qU1b1PmfVXnfPoCThEjMNSdMdW3gBWaRdR50vqd?=
 =?iso-8859-1?Q?d2kF8/mIvOTcmfpXITbgKQnDYUsumNgj5A3Bc5SbLpG+YFghEkPKgxBTrx?=
 =?iso-8859-1?Q?ndIhJVv54nk786N1vVdZxjN4hPGiHYTEUSaIlAEvLYtKejLWdceZjT8NnU?=
 =?iso-8859-1?Q?JIo6WKlfnu7mtFEbbbYWkdt80oYPrDF2kkiRy12W9bowj5ekIWk/Dbd9qh?=
 =?iso-8859-1?Q?kVhb7SRoQMK3LcQ6BLHexcRJrWJqJawLUey0CH1UYDgGOILS9scy9yzEkT?=
 =?iso-8859-1?Q?pfAWTNMWdnRVx7oyukSLSGiJd8M/n+ttv1gGlEesO2hmY3wtss4CNwKr5t?=
 =?iso-8859-1?Q?9N/oFzHtA16o5m8D5DpPsO+siuZ4JBvSLFbyh8MGuyVTP+h5kVnTVxV/pk?=
 =?iso-8859-1?Q?VcxbJoose5U5REumplxTD/tRVdu7pKvnR6ZJ/WXTqIUsNPYlP3/DEcJkA7?=
 =?iso-8859-1?Q?G5pByYM38gfGRx6grPRVHzmUYBDoPLyHMpAj83s3WXQp0CEt1MqAMFr1uA?=
 =?iso-8859-1?Q?imhc3UhgOsUE+x+sdBxtg5FRiNcJIus/I7d7G86zgXSRKUj8Hgws/1DsPA?=
 =?iso-8859-1?Q?lZweDTUU9GhFg6+TAFeWOAwuazTJk/oWdo0S5IpH3QIa2FxtMtKsZB629d?=
 =?iso-8859-1?Q?mw7wwaeDxzXZMNeA4RQneYSRReCn8co1PiCGjXp35O0hy2BG1xPAaldP5E?=
 =?iso-8859-1?Q?dA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:BJXPR01MB198.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:OSPM;SFS:(13230001)(366004)(7366002)(7406005)(7416002)(6200100001)(4270600006)(66946007)(33656002)(38350700002)(55016003)(508600001)(40180700001)(66556008)(66476007)(8676002)(6862004)(9686003)(558084003)(186003)(40160700002)(7116003)(3480700007)(38100700002)(19618925003)(6666004)(2906002)(8936002)(26005)(7696005)(52116002)(86362001)(62346012);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?i2X/MIhROyizJgNjMIFuCa/fJ/oZw/eL8M7tqdR2lD1MsHvj79iCamakHp?=
 =?iso-8859-1?Q?JWHRhMN1XBDevEe6fZA6aWYYQQaqE3pcWh+Fyr1w5s4GiNAk0ijxPjAtL4?=
 =?iso-8859-1?Q?sqXlIw6ILLQQTD5rxNPRoHFUhweKfh8wdf4U0tlNxBA2TX2QuJmd6F6ejk?=
 =?iso-8859-1?Q?cwDGNtRCw7SWJkIGQQ5mfmNiPFdIomNFfBTCxZ3uRESxbbVm7avWpYTlXp?=
 =?iso-8859-1?Q?+CkV+SbkbarNad21LIc3ml30ofNrHGCAY5o6NTbT9nd3UdBbSh2dbP3nxy?=
 =?iso-8859-1?Q?0XygK6tHFZWaokZuuXCLZdv84q14zRMmcy9ta/Fc1P34yg93DUH5NZZH7q?=
 =?iso-8859-1?Q?qDfhoZVloIzCmxMwLMWzur+eaFi95Fd342cUC0TMYnu2CheD7ZQfqNOxbT?=
 =?iso-8859-1?Q?v4XYDVTVsTZbxn6SehqSR/WoUj+yPIHv+IGU2kblo1qehoGmKbexDK69Rz?=
 =?iso-8859-1?Q?eeY+srYrhcmJ3lYyu6ESb7Xlrv2p4hhQYwXsNfbx30CIqWvDy8k88wVICZ?=
 =?iso-8859-1?Q?/JtLaIrnQTG4l8e1kP5PCA74RgP+TbgXqZKGcg6ofn/KoS6BztAXhRpD+r?=
 =?iso-8859-1?Q?tfj610Et22l80kvgcAm3nJgz7LiHkRb0xUST9Rv8Wp41soLG0p8O4wR1Zu?=
 =?iso-8859-1?Q?kU9wLWLcRk0t9OO+jbTRatP+kKEnv+T4U2NX4ornvufRQnceQMKcC1F4GW?=
 =?iso-8859-1?Q?5u5CZSPumUE68I+G4Vy90tb7Q78CT5nzOBMTSqlZPFYPEZmqeysyqMYYsA?=
 =?iso-8859-1?Q?FCBheLQli+2Bl+nAuq5ihzeZelnv0wt4p9RrsYvCFncmOUQf9Pr+oxEY0q?=
 =?iso-8859-1?Q?UYxYzTMsVOZw+hu9/CSl2wuvWEsoWISzCCsmjmxVZjtCoMLA8T7PVHIEQJ?=
 =?iso-8859-1?Q?pdVZXunTi7PFTLUytvA55vAat2kjLGhNg8fWxRDz6MbVWwzYF6gKg4WL12?=
 =?iso-8859-1?Q?p4lrV36A+KXXwfTlRNAuEhPDCZHRBj9oADc+Hhm8N8zYk6x/qoAYSZf8CM?=
 =?iso-8859-1?Q?fn2fo0x4hQd5tPFRBdFE2srfaScoudsmyRBLLwZAOd+qsSc7YsvJXYE9jU?=
 =?iso-8859-1?Q?kc4jI2aW1yvgVULDKZg+S3qE9XBk3yLSrtI6RcD7WoX7n2vfysZdlSBffy?=
 =?iso-8859-1?Q?x66l8XAm/3Ixa5dIxoMI+RdrmP2D1dFY4d7dZaFz3qB+ydov1HdqGPU3s+?=
 =?iso-8859-1?Q?jAtsMamoVP7mjCwLApAEZQGxQQqBi5PFJklJj8f4FdF4aBEuE6F1krEn8E?=
 =?iso-8859-1?Q?YUNmkKZkuDpi7vqOn7fCIzAgChUkNbOjzG09gsOvzzwXrXIMwRbffZyieT?=
 =?iso-8859-1?Q?bete8ekAYlCOR1wtm+iVv2PO7j3sbJrlYxbSLJLqfFXSPVlSSHlnqpJXEF?=
 =?iso-8859-1?Q?uGMaJRDRBH8L1g01+cTmi//JWB1imbNF5teNxFi2Y+vnA2Xx6Po+FwxPub?=
 =?iso-8859-1?Q?85pHV9beMTJirnmqic1EIp8mR4VIeUgpstGxOGYsmcjYOfd5o7dSYvo1Cu?=
 =?iso-8859-1?Q?Ge+nu+ymP/9Og7TurhrAh3oTC4JyAIrN83Xg3g4eKeaG8dKqZL00+kCSHO?=
 =?iso-8859-1?Q?g+yZEstd+NgZUG/+iX/oxP9ppFeWamIOgdk6y9BGDf/554kR11/f7cjbIS?=
 =?iso-8859-1?Q?zlrr6g/5gtSogAR/Lre33fkFWLxzuWRyJUVkfY4QknXegyPZyRRM16KxR7?=
 =?iso-8859-1?Q?5jJ2pG7WsDRYzC3zpjblTxqvP5fCog7dhWjnnRrcPCn/npxBJC1yOS/eqU?=
 =?iso-8859-1?Q?rqH88jcXwu18OKzmWSbPQN5TU=3D?=
X-OriginatorOrg: gientech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51b029b7-c1da-4fb6-7dae-08da3562ac86
X-MS-Exchange-CrossTenant-AuthSource: BJXPR01MB198.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2022 04:31:54.5627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 89592e53-6f9d-4b93-82b1-9f8da689f1b4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: thXQJZBh4hRXRMsZEYnlmuub0Vw1MlHQk48uF8qYKsdmnfrSL4lCedwjxD23GA52mjnVqLgk9GMHY54oSuRHp2n+yJ/nJpTFnz5tNEsoFkI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BJXPR01MB0535
X-Spam-Status: No, score=1.0 required=5.0 tests=BAYES_50,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Can we team up for a job?
